import Foundation

public enum PlayerError: Error, Equatable {
    case trackNotFound
    case networkError(String)
}
