import Foundation

public protocol TrackRepositoryProtocol: AnyObject {
    func searchTracks(query: String) async throws -> [Track]
}
