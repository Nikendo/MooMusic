import Foundation

public struct ITunesResponse: Decodable {
    public let results: [ITunesTrackDTO]
}
