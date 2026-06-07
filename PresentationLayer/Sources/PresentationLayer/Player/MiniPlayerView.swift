import SwiftUI
import Kingfisher

public struct MiniPlayerView: View {
    @EnvironmentObject public var viewModel: PlayerViewModel
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
        KFImage(viewModel.currentTrack?.coverURL)
            .placeholder {
                Color.gray.opacity(0.3)
            }
            .onSuccess { result in
                viewModel.onArtworkLoaded(result.image)
            }
            .resizable()
            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 10)
            .frame(width: 40, height: 40)
            .cornerRadius(12)
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
            Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                .font(.title2)
                .foregroundColor(.primary)
        }
    }
}
