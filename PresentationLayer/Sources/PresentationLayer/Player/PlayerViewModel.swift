import SwiftUI
import Combine
import DomainLayer
import DesignSystem

@MainActor
public final class PlayerViewModel: ObservableObject {
    @Published public private(set) var currentTrack: Track?
    @Published public var currentTime: Double = 0.0
    @Published public private(set) var duration: Double = 0.0
    @Published public private(set) var errorMessage: String?
    @Published public private(set) var isPlaying = false
    @Published public var isLoading = false
    @Published public var isScrubbing = false
    @Published public private(set) var artworkImage: UIImage?
    @Published public private(set) var isOnRepeat = false

    private let searchAndPlayTrackUseCase: SearchAndPlayTrackUseCase
    private let skipTrackUseCase: SkipTrackUseCase
    private let colorExtractorService: ColorExtractorServiceProtocol
    private let audioService: AudioServiceProtocol
    private var cancellables: Set<AnyCancellable> = []

    public init(
        searchAndPlayTrackUseCase: SearchAndPlayTrackUseCase,
        skipTrackUseCase: SkipTrackUseCase,
        colorExtractorService: ColorExtractorServiceProtocol,
        audioService: AudioServiceProtocol
    ) {
        self.searchAndPlayTrackUseCase = searchAndPlayTrackUseCase
        self.skipTrackUseCase = skipTrackUseCase
        self.colorExtractorService = colorExtractorService
        self.audioService = audioService

        bindAudioService()
    }

    public func playTrack(query: String) async {
        isLoading = true
        errorMessage = nil

        do {
            currentTrack = try await searchAndPlayTrackUseCase.execute(query: query)
        } catch let error as PlayerError {
            errorMessage = message(for: error)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    public func togglePlayPause() {
        audioService.togglePlayPause()
    }

    public func seek(to value: Double) {
        audioService.seek(to: value)
    }

    public func skipForward() {
        Task {
            await skipTrack(direction: .forward)
        }
    }

    public func skipBackward() {
        Task {
            await skipTrack(direction: .backward)
        }
    }

    public func formatTime(_ time: Double) -> String {
        guard !time.isNaN && !time.isInfinite else { return "0:00" }
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    public func onArtworkLoaded(_ image: UIImage) {
        artworkImage = image
    }

    public func tapOnRepeat() {
        isOnRepeat.toggle()
    }
}

private extension PlayerViewModel {
    func skipTrack(direction: SkipTrackUseCase.Direction) async {
        isLoading = true
        errorMessage = nil

        do {
            currentTrack = try await skipTrackUseCase.execute(direction: direction)
        } catch let error as PlayerError {
            errorMessage = message(for: error)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func message(for error: PlayerError) -> String {
        switch error {
        case .trackNotFound:
            return Strings.trackNotFound
        case .networkError(let description):
            return Strings.networkError(description)
        }
    }

    func bindAudioService() {
        audioService.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .idle, .paused:
                    self?.isPlaying = false
                case .loading:
                    break
                case .playing:
                    self?.isPlaying = true
                case .error(let message):
                    self?.errorMessage = message
                }
            }
            .store(in: &cancellables)

        audioService.currentTimePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] time in
                guard let self, !self.isScrubbing else { return }
                self.currentTime = time
            }
            .store(in: &cancellables)

        audioService.durationPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$duration)
    }
}
