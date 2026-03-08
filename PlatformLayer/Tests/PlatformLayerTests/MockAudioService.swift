import Foundation
import Combine
@testable import DomainLayer
@testable import PlatformLayer

final class MockAudioService: AudioServiceProtocol {
    let stateSubject = CurrentValueSubject<PlaybackState, Never>(.idle)
    let currentTimeSubject = CurrentValueSubject<Double, Never>(0)
    let durationSubject = CurrentValueSubject<Double, Never>(0)

    var statePublisher: AnyPublisher<PlaybackState, Never> {
        stateSubject.eraseToAnyPublisher()
    }

    var currentTimePublisher: AnyPublisher<Double, Never> {
        currentTimeSubject.eraseToAnyPublisher()
    }

    var durationPublisher: AnyPublisher<Double, Never> {
        durationSubject.eraseToAnyPublisher()
    }

    var playCallCount = 0
    var pauseCallCount = 0
    var seekCallCount = 0
    var lastSeekValue: Double?

    func load(from url: URL) {}
    
    func play() {
        playCallCount += 1
        stateSubject.send(.playing)
    }
    
    func pause() {
        pauseCallCount += 1
        stateSubject.send(.paused)
    }
    
    func togglePlayPause() {}
    
    func seek(to seconds: Double) {
        seekCallCount += 1
        lastSeekValue = seconds
    }
}
