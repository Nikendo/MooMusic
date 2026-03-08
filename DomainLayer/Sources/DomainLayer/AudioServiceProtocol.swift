import Foundation
import Combine

public protocol AudioServiceProtocol {
    var statePublisher: AnyPublisher<PlaybackState, Never> { get }
    var currentTimePublisher: AnyPublisher<Double, Never> { get }
    var durationPublisher: AnyPublisher<Double, Never> { get }
    
    func load(from url: URL)
    func play()
    func pause()
    func togglePlayPause()
    func seek(to seconds: Double)
}
