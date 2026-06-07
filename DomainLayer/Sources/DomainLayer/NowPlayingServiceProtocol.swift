import Foundation

@MainActor
public protocol NowPlayingServiceProtocol: AnyObject {
    func updateNowPlaying(with track: Track)
    func clearNowPlaying()
}
