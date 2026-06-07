import Foundation
import Combine

@MainActor
public final class AppCoordinator: ObservableObject {
    @Published public private(set) var isPlayerExpanded = false

    public let playerViewModel: PlayerViewModel
    public let router: MainRouter

    public init(playerViewModel: PlayerViewModel, router: MainRouter) {
        self.playerViewModel = playerViewModel
        self.router = router
    }

    public func expandPlayer() {
        isPlayerExpanded = true
    }

    public func collapsePlayer() {
        isPlayerExpanded = false
    }

    public func playTrack(query: String) async {
        await playerViewModel.playTrack(query: query)
    }
}
