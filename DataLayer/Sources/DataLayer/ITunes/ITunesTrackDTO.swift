import Foundation

public struct ITunesTrackDTO: Decodable {
    public let trackId: Int
    public let trackName: String?
    public let artistName: String?
    public let artworkUrl100: String?
    public let previewUrl: String?
    public let trackTimeMills: Int?
}
