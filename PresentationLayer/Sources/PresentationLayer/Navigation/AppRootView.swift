import SwiftUI

public struct AppRootView: View {
    @ObservedObject private var coordinator: AppCoordinator
    @ObservedObject private var router: MainRouter
    @ObservedObject private var playerViewModel: PlayerViewModel

    public init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        self.router = coordinator.router
        self.playerViewModel = coordinator.playerViewModel
    }

    public var body: some View {
        ZStack {
            TabView(selection: $router.selectedTab) {
                HomeView(
                    playerViewModel: playerViewModel,
                    onPlayTrack: { query in
                        Task {
                            await coordinator.playTrack(query: query)
                        }
                    }
                )
                .tabItem {
                    Label("Home", systemImage: "music.note.house.fill")
                }
                .tag(MainTab.home)

                RadioView()
                    .tabItem {
                        Label("Radio", systemImage: "dot.radiowaves.left.and.right")
                    }
                    .tag(MainTab.radio)
            }

            if coordinator.isPlayerExpanded {
                PlayerView(onDismiss: coordinator.collapsePlayer)
                    .environmentObject(playerViewModel)
                    .transition(.move(edge: .bottom))
                    .zIndex(2)
            }

            if playerViewModel.currentTrack != nil && !coordinator.isPlayerExpanded {
                VStack {
                    Spacer()
                    MiniPlayerView(onExpand: coordinator.expandPlayer)
                        .environmentObject(playerViewModel)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 64)
                }
                .zIndex(1)
            }
        }
        .animation(.spring, value: coordinator.isPlayerExpanded)
        .animation(.spring, value: playerViewModel.currentTrack != nil)
    }
}
