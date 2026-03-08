import Foundation

public struct Track: Equatable, Sendable {
    public let id: String
    public let title: String
    public let artist: String
    public let coverURL: URL?
    public let previewURL: URL
    public let duration: Double

    public init(
        id: String,
        title: String,
        artist: String,
        coverURL: URL?,
        previewURL: URL,
        duration: Double
    ) {
        self.id = id
        self.title = title
        self.artist = artist
        self.coverURL = coverURL
        self.previewURL = previewURL
        self.duration = duration
    }
}
