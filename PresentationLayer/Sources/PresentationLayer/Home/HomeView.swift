import SwiftUI
import DesignSystem

private enum SampleTrack {
    static let query = "Bed Chem - Sabrina Carpenter"
}

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
                    Strings.homeScreen

                    Button {
                        onPlayTrack(SampleTrack.query)
                    } label: {
                        Strings.homePlayDemo
                    }
                    .accessibilityIdentifier("home.playDemoTrackButton")
                }
            }
            .navigationTitle(Strings.homeNavigationTitle)
        }
    }
}
