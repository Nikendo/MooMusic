import SwiftUI

public struct RootView: View {
    @EnvironmentObject var playerViewModel: PlayerViewModel
    @State private var isPlayerExpanded = false

    public init() {}

    public var body: some View {
        ZStack(alignment: .bottom) {
            TabView {
                homeView
                radioView
            }

            if playerViewModel.currentTrack != nil {
                MiniPlayerView {
                    isPlayerExpanded = true
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 64)
                .transition(.move(edge: .bottom))
                .animation(.spring, value: playerViewModel.currentTrack != nil)
            }
        }
        .fullScreenCover(isPresented: $isPlayerExpanded) {
            PlayerView()
        }
    }
}

private extension RootView {
    var backgroundView: some View {
        playerViewModel.palette.background.ignoresSafeArea()
    }

    var homeView: some View {
        NavigationView {
            ZStack {
                backgroundView

                VStack {
                    Text("Home screen")

                    Button("A random track for test") {
                        Task {
                            await playerViewModel.fetchAndPlayTrack(query: "Bed Chem - Sabrina Carpenter")
                        }
                    }
                }
            }
            .navigationTitle("Search")
        }
        .tabItem {
            Label("Home", systemImage: "music.note.house.fill")
        }
    }

    var radioView: some View {
        NavigationView {
            VStack {
                Text("Radio screen")
                Text("In development")
            }
            .navigationTitle("Radio")
        }
        .tabItem {
            Label("Radio", systemImage: "dot.radiowaves.left.and.right")
        }
    }
}
