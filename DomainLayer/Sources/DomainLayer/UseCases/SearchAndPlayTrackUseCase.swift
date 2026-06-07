import Foundation

@MainActor
public final class SearchAndPlayTrackUseCase {
    private let trackRepository: TrackRepositoryProtocol
    private let audioService: AudioServiceProtocol
    private let nowPlayingService: NowPlayingServiceProtocol
    private let playbackQueueService: PlaybackQueueService

    public init(
        trackRepository: TrackRepositoryProtocol,
        audioService: AudioServiceProtocol,
        nowPlayingService: NowPlayingServiceProtocol,
        playbackQueueService: PlaybackQueueService
    ) {
        self.trackRepository = trackRepository
        self.audioService = audioService
        self.nowPlayingService = nowPlayingService
        self.playbackQueueService = playbackQueueService
    }

    public func execute(query: String) async throws -> Track {
        let tracks: [Track]
        do {
            tracks = try await trackRepository.searchTracks(query: query)
        } catch {
            throw PlayerError.networkError(error.localizedDescription)
        }

        guard let track = tracks.first else {
            throw PlayerError.trackNotFound
        }

        audioService.load(from: track.previewURL)
        nowPlayingService.updateNowPlaying(with: track)
        playbackQueueService.setCurrentQuery(query)

        return track
    }
}
