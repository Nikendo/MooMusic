import SwiftUI
import DesignSystem

public struct MiniPlayerView: View {
    @EnvironmentObject public var viewModel: PlayerViewModel
    
    public let namespace: Namespace.ID
    
    public var onExpand: () -> Void

    public var body: some View {
        HStack(spacing: 12) {
            albumCoverView
            trackInfoView
            Spacer()
            playButtonView
                .padding(.trailing, 8)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 8)
        .background(.regularMaterial)
        .cornerRadius(18)
        .onTapGesture(perform: onExpand)
    }
}

private extension MiniPlayerView {
    var albumCoverView: some View {
        PlayerAlbumCoverAnchor(namespace: namespace, slot: .mini)
    }

    var trackInfoView: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(viewModel.currentTrack?.title ?? "")
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(1)

            Text(viewModel.currentTrack?.artist ?? "")
                .font(.footnote)
                .fontWeight(.regular)
                .lineLimit(1)
        }
    }
    
    var playButtonView: some View {
        Button(action: viewModel.togglePlayPause) {
            (viewModel.isPlaying ? DesignSymbol.pause : DesignSymbol.play).image
                .font(.title2)
                .foregroundColor(.primary)
        }
        .accessibilityIdentifier("miniPlayer.playPauseButton")
    }
}
