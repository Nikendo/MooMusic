import XCTest
import MediaPlayer
@testable import DomainLayer
@testable import PlatformLayer

final class NowPlayingManagerTests: XCTestCase {
    private var mockAudioService: MockAudioService!
    private var nowPlayingManager: NowPlayingManager!

    override func setUp() {
        super.setUp()
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
        mockAudioService = MockAudioService()
        nowPlayingManager = NowPlayingManager(audioService: mockAudioService)
    }

    override func tearDown() {
        mockAudioService = nil
        nowPlayingManager = nil
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
        super.tearDown()
    }

    func test_updateNowPlaying_setsCorrectMetadataInSystem() {
        // Given
        let track = Track(
            id: "1",
            title: "Gato Negro",
            artist: "Javi Medina",
            coverURL: nil,
            previewURL: URL(string: "https://test.com")!,
            duration: 176.0
        )

        // When
        nowPlayingManager.updateNowPlaying(with: track)

        // Then
        let info = MPNowPlayingInfoCenter.default().nowPlayingInfo
        XCTAssertNotNil(info, "Info center mustn't be empty")
        XCTAssertEqual(info?[MPMediaItemPropertyTitle] as? String, "Gato Negro")
        XCTAssertEqual(info?[MPMediaItemPropertyArtist] as? String, "Javi Medina")
        XCTAssertEqual(info?[MPMediaItemPropertyPlaybackDuration] as? Double, 176.0)
    }

    func test_clearNowPlaying_removeMetadataFromSystem() {
        // Given
        let track = Track(
            id: "1",
            title: "Gato Negro",
            artist: "Javi Medina",
            coverURL: nil,
            previewURL: URL(string: "https://test.com")!,
            duration: 176.0
        )
        nowPlayingManager.updateNowPlaying(with: track)

        // When
        nowPlayingManager.clearNowPlaying()

        // Then
        let info = MPNowPlayingInfoCenter.default().nowPlayingInfo
        XCTAssertNil(info, "Info center must be empty")
    }

    func test_audioServiceChangesToStatePaused_updatesPlaybackRateToZero() {
        // Given
        let track = Track(
            id: "1",
            title: "Gato Negro",
            artist: "Javi Medina",
            coverURL: nil,
            previewURL: URL(string: "https://test.com")!,
            duration: 176.0
        )
        nowPlayingManager.updateNowPlaying(with: track)
        mockAudioService.stateSubject.send(.playing)

        // When
        mockAudioService.stateSubject.send(.paused)

        // Then
        let info = MPNowPlayingInfoCenter.default().nowPlayingInfo
        XCTAssertEqual(info?[MPNowPlayingInfoPropertyPlaybackRate] as? Double, 0.0)
    }

    func test_audioServiceUpdatesTime_updatesElapsedTimeInSsytem() {
        // Given
        let track = Track(
            id: "1",
            title: "Gato Negro",
            artist: "Javi Medina",
            coverURL: nil,
            previewURL: URL(string: "https://test.com")!,
            duration: 176.0
        )
        nowPlayingManager.updateNowPlaying(with: track)
        mockAudioService.stateSubject.send(.playing)

        // When
        mockAudioService.currentTimeSubject.send(45.0)

        // Then
        let info = MPNowPlayingInfoCenter.default().nowPlayingInfo
        XCTAssertEqual(info?[MPNowPlayingInfoPropertyElapsedPlaybackTime] as? Double, 45.0)
    }
}
