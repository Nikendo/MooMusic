import Foundation

public final class PlaybackQueueService: @unchecked Sendable {
    private let queries: [String]
    private var currentIndex: Int

    public init(
        queries: [String] = PlaybackQueueService.defaultQueries,
        currentIndex: Int = 0
    ) {
        self.queries = queries
        self.currentIndex = currentIndex
    }

    public func currentQuery() -> String {
        queries[currentIndex]
    }

    @discardableResult
    public func moveNext() -> String {
        currentIndex = currentIndex < queries.count - 1 ? currentIndex + 1 : 0
        return currentQuery()
    }

    @discardableResult
    public func movePrevious() -> String {
        currentIndex = currentIndex > 0 ? currentIndex - 1 : queries.count - 1
        return currentQuery()
    }

    public func setCurrentQuery(_ query: String) {
        guard let index = queries.firstIndex(of: query) else { return }
        currentIndex = index
    }
}

public extension PlaybackQueueService {
    static let defaultQueries = [
        "Soda Island",
        "Javi Medina - Gitana",
        "Shifty Brent - Without Me (1960's"
    ]
}
