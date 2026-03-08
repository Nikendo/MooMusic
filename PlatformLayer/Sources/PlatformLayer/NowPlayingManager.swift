import Foundation
import MediaPlayer
import Combine
import DomainLayer

public final class NowPlayingManager {
    private let audioService: AudioServiceProtocol
    private var cancellables: Set<AnyCancellable> = []

    private var currentTrack: Track?

    public init(audioService: AudioServiceProtocol) {
        self.audioService = audioService
        setupRemoteCommandCenter()
        bindAudioServiceState()
    }

    public func updateNowPlaying(with track: Track) {
        self.currentTrack = track
        updateMetadata()
    }

    public func clearNowPlaying() {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
    }
}

private extension NowPlayingManager {

    func setupRemoteCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared()

        commandCenter.playCommand.removeTarget(nil)
        commandCenter.pauseCommand.removeTarget(nil)
        commandCenter.changePlaybackPositionCommand.removeTarget(nil)

        commandCenter.playCommand.addTarget { [weak audioService] _ in
            audioService?.play()
            return .success
        }

        commandCenter.pauseCommand.addTarget { [weak audioService] _ in
            audioService?.pause()
            return .success
        }

        commandCenter.changePlaybackPositionCommand.addTarget { [weak audioService] event in
            guard let positionEvent = event as? MPChangePlaybackPositionCommandEvent else { return .commandFailed }
            audioService?.seek(to: positionEvent.positionTime)
            return .success
        }
    }

    func bindAudioServiceState() {
        audioService.statePublisher
            .sink { [weak self] state in
                self?.updatePlaybackState(state)
            }
            .store(in: &cancellables)

        audioService.currentTimePublisher
            .sink { [weak self] time in
                self?.updateElapsedTime(time)
            }
            .store(in: &cancellables)
    }

    func updateMetadata() {
        guard let track = currentTrack else { return }

        var nowPlayingInfo: [String: Any] = [
            MPMediaItemPropertyTitle: track.title,
            MPMediaItemPropertyArtist: track.artist,
            MPMediaItemPropertyPlaybackDuration: track.duration
        ]

        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }

    func updatePlaybackState(_ state: PlaybackState) {
        var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo ?? [String: Any]()

        switch state {
        case .playing:
            nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1.0
        case .paused, .idle, .error:
            nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 0.0
        default:
            break
        }

        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }

    func updateElapsedTime(_ time: Double) {
        var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo ?? [String: Any]()
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = time
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
}
