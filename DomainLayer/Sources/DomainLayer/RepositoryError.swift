import Foundation

public enum RepositoryError: Error {
    case networkError(Error)
    case invalidData
    case invalidURL
}
