import Foundation

public protocol TrackRepositoryProtocol: Sendable {
    func searchTracks(query: String) async throws -> [Track]
}
