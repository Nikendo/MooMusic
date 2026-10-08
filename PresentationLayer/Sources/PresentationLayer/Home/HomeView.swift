import SwiftUI
import DesignSystem

public struct HomeView: View {
    @ObservedObject private var playerViewModel: PlayerViewModel
    private let onPlayTrack: (String) -> Void

    public init(
        playerViewModel: PlayerViewModel,
        onPlayTrack: @escaping (String) -> Void
    ) {
        self.playerViewModel = playerViewModel
        self.onPlayTrack = onPlayTrack
    }

    public var body: some View {
        NavigationStack {
            ZStack {
                AdaptiveBackgroundView(image: playerViewModel.artworkImage)
                    .ignoresSafeArea()

                VStack {
                    Text("Home screen")

                    Button("A random track for test") {
                        onPlayTrack("Bed Chem - Sabrina Carpenter")
                    }
                    .accessibilityIdentifier("home.playDemoTrackButton")
                }
            }
            .navigationTitle("Search")
        }
    }
}
