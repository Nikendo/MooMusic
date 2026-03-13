import SwiftUI
import DomainLayer
import Kingfisher

public struct PlayerView: View {
    @StateObject private var viewModel: PlayerViewModel

    public init(viewModel: PlayerViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        ZStack {
            viewModel.palette.background
                .ignoresSafeArea()

            VStack(spacing: 32) {
                headerView

                Spacer()

                albumCoverView

                Spacer()

                VStack(spacing: 24) {
                    metadataView
                    progressView
                    controlsView
                    secondaryActionsView
                }
                .padding(.horizontal, 24)

                Spacer()
            }
        }
        .animation(.easeInOut, value: viewModel.palette)
        .task {
            await viewModel.fetchAndPlayTrack(query: "Soda Island")
        }
    }
}

private extension PlayerView {
    var headerView: some View {
        Text("My vibe")
            .font(.headline)
            .foregroundColor(viewModel.palette.secondaryText)
            .padding(.top, 16)
    }

    var albumCoverView: some View {
        KFImage(viewModel.currentTrack?.coverURL)
            .placeholder {
                Color.gray.opacity(0.3)
            }
            .onSuccess { result in
                viewModel.onArtworkLoaded(result.image)
            }
            .onFailure { error in
                print("Loading artwork error: \(error.localizedDescription)")
            }
            .resizable()
            .aspectRatio(contentMode: .fit)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 10)
            .frame(width: 320, height: 320)
            .padding(.top, 20)
    }

    var metadataView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.currentTrack?.title ?? "Loading...")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(viewModel.palette.primaryText)

                Text(viewModel.currentTrack?.artist ?? "Artist")
                    .font(.subheadline)
                    .foregroundColor(viewModel.palette.secondaryText)
            }
            Spacer()

            Button(action: { /* Like action */ }) {
                Image(systemName: "heart")
                    .foregroundColor(viewModel.palette.secondaryText)
            }
        }
    }

    var progressView: some View {
        VStack(spacing: 8) {
            ProgressSlider(
                value: $viewModel.currentTime,
                range: 0...(viewModel.duration > 0 ? viewModel.duration : 1),
                isScrubbing: $viewModel.isScrubbing,
                onEditingChanged: {
                    viewModel.seek(to: viewModel.currentTime)
                },
                activeColor: viewModel.palette.accent,
                inactiveColor: viewModel.palette.secondaryText.opacity(0.3)
            )

            HStack {
                Text(viewModel.formatTime(viewModel.currentTime))
                Spacer()
                Text(viewModel.formatTime(viewModel.duration))
            }
            .font(.system(size: 12, weight: .medium, design: .default))
            .foregroundColor(viewModel.palette.secondaryText.opacity(0.5))
        }
    }

    var controlsView: some View {
        HStack(spacing: 40) {
            Button(action: { viewModel.skipBackward() }) {
                Image(systemName: "backward.fill")
                    .font(.title)
            }

            Button(action: { viewModel.togglePlayPause() }) {
                Image(systemName: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .font(.system(size: 64))
                    .foregroundColor(viewModel.palette.accent)
            }

            Button(action: { viewModel.skipForward() }) {
                Image(systemName: "forward.fill")
                    .font(.title)
            }
        }
        .foregroundColor(viewModel.palette.secondaryText)
    }
    
    var secondaryActionsView: some View {
        HStack {
            Button(action: viewModel.tapOnRepeat) {
                Image(systemName: "repeat")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(viewModel.isOnRepeat ? viewModel.palette.secondaryText : viewModel.palette.secondaryText.opacity(0.5))
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(
                        Capsule()
                            .fill(viewModel.palette.secondaryText.opacity(0.1))
                    )
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "text.alignleft")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(viewModel.palette.secondaryText.opacity(0.5))
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(
                        Capsule()
                            .fill(viewModel.palette.secondaryText.opacity(0.1))
                    )
            }
            .disabled(true)
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "arrow.down.circle")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(viewModel.palette.secondaryText.opacity(0.5))
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(
                        Capsule()
                            .fill(viewModel.palette.secondaryText.opacity(0.1))
                    )
            }
            .disabled(true)
        }
        .padding(.horizontal, 24)
    }
}
