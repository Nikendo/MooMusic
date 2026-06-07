import Foundation
import DomainLayer
import DataLayer
import PlatformLayer
import PresentationLayer

@MainActor
final class DependencyContainer {
    static let shared = DependencyContainer()

    // MARK: - Platform Services

    private(set) lazy var audioService: AudioServiceProtocol = AudioPlayerService()
    private(set) lazy var trackRepository: TrackRepositoryProtocol = ITunesTrackRepository()
    private(set) lazy var colorExtractorService: ColorExtractorServiceProtocol = ColorExtractorService()

    private(set) lazy var nowPlayingManager: NowPlayingManager = {
        NowPlayingManager(audioService: audioService)
    }()

    // MARK: - Domain Services

    private(set) lazy var playbackQueueService = PlaybackQueueService()

    // MARK: - Use Cases

    private(set) lazy var searchAndPlayTrackUseCase = SearchAndPlayTrackUseCase(
        trackRepository: trackRepository,
        audioService: audioService,
        nowPlayingService: nowPlayingManager,
        playbackQueueService: playbackQueueService
    )

    private(set) lazy var skipTrackUseCase = SkipTrackUseCase(
        trackRepository: trackRepository,
        audioService: audioService,
        nowPlayingService: nowPlayingManager,
        playbackQueueService: playbackQueueService
    )

    // MARK: - View Models

    private(set) lazy var playerViewModel = PlayerViewModel(
        searchAndPlayTrackUseCase: searchAndPlayTrackUseCase,
        skipTrackUseCase: skipTrackUseCase,
        colorExtractorService: colorExtractorService,
        audioService: audioService
    )

    // MARK: - Navigation

    private(set) lazy var mainRouter = MainRouter()
    private(set) lazy var appCoordinator = AppCoordinator(
        playerViewModel: playerViewModel,
        router: mainRouter
    )

    private init() {}
}
