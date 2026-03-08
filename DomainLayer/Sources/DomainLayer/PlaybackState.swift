import Foundation

public enum PlaybackState: Equatable {
    case idle
    case loading
    case playing
    case paused
    case error(String)
}
