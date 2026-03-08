import Combine
import AVFoundation
import XCTest
@testable import DomainLayer
@testable import DataLayer

final class AudioPlayerServiceTests: XCTestCase {
    private var audioPlayerService: AudioPlayerService!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        audioPlayerService = AudioPlayerService()
        cancellables = []
    }

    override func tearDown() {
        audioPlayerService = nil
        cancellables = nil
        super.tearDown()
    }

    func test_initialState_isIdle() {
        // Given
        let expectation = XCTestExpectation(description: "Get initial state")
        var receivedState: PlaybackState?

        audioPlayerService.statePublisher
            .first()
            .sink { state in
                receivedState = state
                expectation.fulfill()
            }
            .store(in: &cancellables)
        // When
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedState, .idle, "The service has to be in '.indle' state when it initializes")
    }

    func testPlayCommand_changesStateToPlaying() {
        // Given
        let expectation = XCTestExpectation(description: "The state changes to '.playing' when press play")

        audioPlayerService.statePublisher
            .dropFirst()
            .sink { state in
                if state == .playing {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        // When
        audioPlayerService.play()

        // Then
        wait(for: [expectation], timeout: 1.0)
    }

    func testPauseCommand_changesStateToPause() {
        // Given
        let expectation = XCTestExpectation(description: "The state changes to '.pause' when press pause")

        audioPlayerService.statePublisher
            .dropFirst()
            .sink { state in
                if state == .paused {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        // When
        audioPlayerService.pause()

        // Then
        wait(for: [expectation], timeout: 1.0)
    }

    func test_audioSessionInterrputionBegan_pausesPlayback() {
        // Given
        audioPlayerService.play()
        let expectation = XCTestExpectation(description: "The call pauses the player")

        audioPlayerService.statePublisher
            .dropFirst()
            .sink { state in
                if state == .paused {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        // When
        let userInfo: [AnyHashable: Any] = [
            AVAudioSessionInterruptionTypeKey: AVAudioSession.InterruptionType.began.rawValue
        ]
        NotificationCenter.default.post(
            name: AVAudioSession.interruptionNotification,
            object: nil,
            userInfo: userInfo
        )

        // Then
        wait(for: [expectation], timeout: 1.0)
    }
}
