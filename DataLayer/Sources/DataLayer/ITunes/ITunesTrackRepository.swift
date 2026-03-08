import Foundation
import DomainLayer

public final class ITunesTrackRepository: TrackRepositoryProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder = JSONDecoder()

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func searchTracks(query: String) async throws -> [Track] {
        guard var components = URLComponents(string: "https://itunes.apple.com/search") else {
            throw RepositoryError.invalidURL
        }

        components.queryItems = [
            URLQueryItem(name: "term", value: query),
            URLQueryItem(name: "media", value: "music"),
            URLQueryItem(name: "entity", value: "song"),
            URLQueryItem(name: "limit", value: "15")
        ]

        guard let url = components.url else {
            throw RepositoryError.invalidURL
        }

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(from: url)
        } catch {
            throw RepositoryError.networkError(error)
        }

        guard
            let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode)
        else {
            throw RepositoryError.invalidData
        }

        let itunesReponse: ITunesResponse
        do {
            itunesReponse = try decoder.decode(ITunesResponse.self, from: data)
        } catch {
            throw RepositoryError.invalidData
        }

        return itunesReponse.results.compactMap { dto in
            let id = dto.trackId
            guard
                let title = dto.trackName,
                let artist = dto.artistName,
                let previewString = dto.previewUrl,
                let previewURL = URL(string: previewString)
            else {
                return nil
            }

            var highResArtworkURL: URL? = nil
            if let artworkString = dto.artworkUrl100 {
                let highResString = artworkString.replacingOccurrences(of: "100x100bb", with: "600x600bb")
                highResArtworkURL = URL(string: highResString)
            }

            let duration = Double(dto.trackTimeMills ?? 30000) / 1000.0

            return Track(
                id: String(id),
                title: title,
                artist: artist,
                coverURL: highResArtworkURL,
                previewURL: previewURL,
                duration: duration
            )
        }
    }
}
