import SwiftUI
import DesignSystem

public struct AppRootView: View {
    @ObservedObject private var coordinator: AppCoordinator
    @ObservedObject private var router: MainRouter
    @ObservedObject private var playerViewModel: PlayerViewModel

    @Namespace private var namespace
    
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
                    Label {
                        Strings.tabHome
                    } icon: {
                        DesignSymbol.home.image
                    }
                }
                .tag(MainTab.home)

                RadioView()
                    .tabItem {
                        Label {
                            Strings.tabRadio
                        } icon: {
                            DesignSymbol.radio.image
                        }
                    }
                    .tag(MainTab.radio)
            }

            if playerViewModel.currentTrack != nil {
                PlayerView(namespace: namespace, onDismiss: collapsePlayer)
                    .environmentObject(playerViewModel)
                    .opacity(coordinator.isPlayerExpanded ? 1 : 0)
                    .allowsHitTesting(coordinator.isPlayerExpanded)
                    .accessibilityHidden(!coordinator.isPlayerExpanded)
                    .zIndex(1)

                VStack {
                    Spacer()
                    MiniPlayerView(namespace: namespace, onExpand: expandPlayer)
                        .environmentObject(playerViewModel)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 64)
                }
                .opacity(coordinator.isPlayerExpanded ? 0 : 1)
                .allowsHitTesting(!coordinator.isPlayerExpanded)
                .accessibilityHidden(coordinator.isPlayerExpanded)
                .zIndex(1)

                PlayerAlbumCoverHero(
                    url: playerViewModel.currentTrack?.coverURL,
                    namespace: namespace,
                    onArtworkLoaded: { image in
                        playerViewModel.onArtworkLoaded(image)
                    }
                )
                .zIndex(2)
            }
        }
        .environment(\.isPlayerExpanded, coordinator.isPlayerExpanded)
        .animation(PlayerAlbumCoverGeometry.animation, value: coordinator.isPlayerExpanded)
        .animation(.spring(response: 0.35, dampingFraction: 0.9), value: playerViewModel.currentTrack != nil)
    }

    private func expandPlayer() {
        withAnimation(PlayerAlbumCoverGeometry.animation) {
            coordinator.expandPlayer()
        }
    }

    private func collapsePlayer() {
        withAnimation(PlayerAlbumCoverGeometry.animation) {
            coordinator.collapsePlayer()
        }
    }
}
