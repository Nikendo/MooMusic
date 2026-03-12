import SwiftUI
import Combine
import DomainLayer
import PlatformLayer

@MainActor
public final class PlayerViewModel: ObservableObject {
    @Published public private(set) var currentTrack: Track?
    @Published public var currentTime: Double = 0.0
    @Published public private(set) var duration: Double = 0.0
    @Published public private(set) var errorMessage: String?
    @Published public private(set) var isPlaying = false
    @Published public var isLoading = false
    @Published public var isScrubbing = false
    @Published public private(set) var palette: AdaptivePalette = .default
    @Published public private(set) var isOnRepeat = false

    private let artists = [
        "Soda Island",
        "Javi Medina - Gitana",
        "Shifty Brent - Without Me (1960's"
    ]

    private var lastTrackIndex = 0

    private let audioService: AudioServiceProtocol
    private let trackRepository: TrackRepositoryProtocol
    private let colorExtractorService: ColorExtractorService
    private var cancellables: Set<AnyCancellable> = []

    public init(
        audioService: AudioServiceProtocol,
        trackRepository: TrackRepositoryProtocol,
        colorExtractorService: ColorExtractorService
    ) {
        self.audioService = audioService
        self.trackRepository = trackRepository
        self.colorExtractorService = colorExtractorService

        bindAudioService()
    }

    public func fetchAndPlayTrack(query: String) async {
        isLoading = true
        errorMessage = nil

        do {
            let tracks = try await trackRepository.searchTracks(query: query)
            if let firstTrack = tracks.first {
                self.currentTrack = firstTrack
                audioService.load(from: firstTrack.previewURL)
            } else {
                errorMessage = "Track not found"
            }
        } catch {
            errorMessage = "Network error: \(error.localizedDescription)"
        }

        isLoading = false
    }

    public func fetchAndPlayLast() async {
        isLoading = true
        errorMessage = nil

        do {
            let tracks = try await trackRepository.searchTracks(query: artists[lastTrackIndex])
            if let firstTrack = tracks.first {
                self.currentTrack = firstTrack
                audioService.load(from: firstTrack.previewURL)
            } else {
                errorMessage = "Track not found"
            }
        } catch {
            errorMessage = "Network error: \(error.localizedDescription)"
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
        // Go to next track

        // TODO: Implement normal logic. This code just for demo
//        let newTime = min(currentTime + 10, duration)
//        seek(to: newTime)

        if lastTrackIndex < artists.count - 1 {
            lastTrackIndex += 1
        } else {
            lastTrackIndex = 0
        }
        Task {
            await fetchAndPlayLast()
        }
    }

    public func skipBackward() {
        // Go to previous track

        // TODO: Implement normal logic. This code just for demo
//        let newTime = min(currentTime - 10, 0)
//        seek(to: newTime)

        if lastTrackIndex > 0 {
            lastTrackIndex -= 1
        } else {
            lastTrackIndex = artists.count - 1
        }
        Task {
            await fetchAndPlayLast()
        }
    }

    public func formatTime(_ time: Double) -> String {
        guard !time.isNaN && !time.isInfinite else { return "0:00" }
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    public func onArtworkLoaded(_ image: UIImage) {
        Task {
            if let color = await colorExtractorService.extractDominantColor(from: image) {
                let newPalette = color.generateAdaptivePalette()
                await MainActor.run {
                    self.palette = newPalette
                }
            }
        }
    }

    public func tapOnRepeat() {
        isOnRepeat.toggle()
    }
}

private extension PlayerViewModel {

    func bindAudioService() {
        audioService.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .idle, .paused:
                    self?.isPlaying = false
                case .loading:
                    // TODO: show loading indicator or something like that
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
