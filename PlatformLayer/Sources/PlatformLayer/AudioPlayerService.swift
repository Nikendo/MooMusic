import AVFoundation
import Combine
import DomainLayer

public class AudioPlayerService: AudioServiceProtocol {

    private let stateSubject = CurrentValueSubject<PlaybackState, Never>(.idle)
    private let currentTimeSubject = CurrentValueSubject<Double, Never>(0)
    private let durationSubject = CurrentValueSubject<Double, Never>(0)

    public var statePublisher: AnyPublisher<PlaybackState, Never> {
        stateSubject.eraseToAnyPublisher()
    }

    public var currentTimePublisher: AnyPublisher<Double, Never> {
        currentTimeSubject.eraseToAnyPublisher()
    }

    public var durationPublisher: AnyPublisher<Double, Never> {
        durationSubject.eraseToAnyPublisher()
    }

    private var player: AVPlayer?
    private var timeObserverToken: Any?
    private var cancellables: Set<AnyCancellable> = []

    public init() {
        setupAudioSession()
        setupNotifications()
    }

    deinit {
        removeTimeOserver()
    }

    public func load(from url: URL) {
        stateSubject.send(.loading)

        let asset: AVAsset = if #available(iOS 18, *) {
            AVURLAsset(url: url)
        } else {
            AVAsset(url: url)
        }

        let playerItem = AVPlayerItem(asset: asset)

        if let player {
            player.replaceCurrentItem(with: playerItem)
        } else {
            player = AVPlayer(playerItem: playerItem)
            addTimeObserver()
        }

        observePlayerItem(playerItem)
        play()
    }
    
    public func play() {
        player?.play()
        stateSubject.send(.playing)
    }
    
    public func pause() {
        player?.pause()
        stateSubject.send(.paused)
    }
    
    public func togglePlayPause() {
        stateSubject.value == .playing ? pause() : play()
    }
    
    public func seek(to seconds: Double) {
        player?.seek(
            to: CMTime(seconds: seconds, preferredTimescale: 600),
            toleranceBefore: .zero,
            toleranceAfter: .zero
        )
    }
}


private extension AudioPlayerService {

    func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set audio session category: \(error)")
        }
    }

    func setupNotifications() {
        let notificationCenter = NotificationCenter.default

        setupInterruptionNotifications(notificationCenter)
        setupAudioOutputChangedNotification(notificationCenter)
    }

    func setupInterruptionNotifications(_ nc: NotificationCenter) {
        nc.publisher(for: AVAudioSession.interruptionNotification)
            .sink { [weak self] notification in
                guard
                    let userInfo = notification.userInfo,
                    let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
                    let type = AVAudioSession.InterruptionType(rawValue: typeValue)
                else {
                    return
                }

                if type == .began {
                    self?.pause()
                } else if type == .ended {
                    guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else {
                        return
                    }

                    let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)

                    guard options.contains(.shouldResume) else { return }

                    self?.play()
                }
            }
            .store(in: &cancellables)
    }

    func setupAudioOutputChangedNotification(_ nc: NotificationCenter) {
        nc.publisher(for: AVAudioSession.routeChangeNotification)
            .sink { [weak self] notification in
                guard
                    let userInfo = notification.userInfo,
                    let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
                    let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue)
                else {
                    return
                }

                if reason == .oldDeviceUnavailable {
                    self?.pause()
                }
            }
            .store(in: &cancellables)
    }

    func observePlayerItem(_ item: AVPlayerItem) {
        cancellables.removeAll()

        item.publisher(for: \.status)
            .sink { [weak self] status in
                switch status {
                case .readyToPlay:
                    guard let duration = self?.player?.currentItem?.duration.seconds else {
                        return
                    }

                    self?.durationSubject.send(duration)
                case .failed:
                    self?.stateSubject.send(.error("Track loading error"))
                case .unknown:
                    break
                @unknown default:
                    break
                }
            }
            .store(in: &cancellables)

        // observing bufferization
        item.publisher(for: \.isPlaybackLikelyToKeepUp)
            .sink { [weak self] isLikelyToKeepUp in
                guard let self else { return }

                if !isLikelyToKeepUp && self.stateSubject.value == .loading {
                    self.stateSubject.send(.loading)
                } else if isLikelyToKeepUp && self.stateSubject.value == .playing {
                    self.stateSubject.send(.playing)
                }
            }
            .store(in: &cancellables)
    }

    func addTimeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.currentTimeSubject.send(time.seconds)
        }
    }

    func removeTimeOserver() {
        guard let timeObserverToken else {
            return
        }

        player?.removeTimeObserver(timeObserverToken)
        self.timeObserverToken = nil
    }
}
