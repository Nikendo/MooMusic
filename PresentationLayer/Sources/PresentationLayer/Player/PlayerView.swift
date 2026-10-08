import SwiftUI
import DesignSystem
import DomainLayer

public struct PlayerView: View {
    @EnvironmentObject public var viewModel: PlayerViewModel
    
    private let namespace: Namespace.ID
    private let onDismiss: () -> Void

    public init(namespace: Namespace.ID, onDismiss: @escaping () -> Void = {}) {
        self.namespace = namespace
        self.onDismiss = onDismiss
    }

    public var body: some View {
        VStack(spacing: 32) {
            Spacer(minLength: 0)

            albumCoverView

            Spacer(minLength: 0)

            VStack(spacing: 24) {
                metadataView
                progressView
                controlsView
                secondaryActionsView
            }
            .padding(.horizontal, 24)

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animation(.easeInOut, value: viewModel.currentTrack)
        .background {
            AdaptiveBackgroundView(image: viewModel.artworkImage)
                .ignoresSafeArea()
        }
        .safeAreaInset(edge: .top) {
            headerView
                .padding(.top)
        }
    }
}

private extension PlayerView {
    var headerView: some View {
        ZStack {
            Strings.playerVibe
                .font(.headline)
                .foregroundColor(DesignTokens.Colors.fillPrimary)

            HStack {
                closeButtonView
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
    }

    var closeButtonView: some View {
        Button(action: onDismiss) {
            DesignSymbol.dismiss.image
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(DesignTokens.Colors.fillPrimary)
        }
        .accessibilityIdentifier("player.dismissButton")
        .frame(width: 48, height: 48)
    }

    var albumCoverView: some View {
        PlayerAlbumCoverAnchor(namespace: namespace, slot: .full)
            .padding(.top, 20)
    }

    var metadataView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.currentTrack?.title ?? Strings.playerLoading)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(DesignTokens.Colors.textPrimary)

                Text(viewModel.currentTrack?.artist ?? Strings.playerUnknownArtist)
                    .font(.subheadline)
                    .foregroundColor(DesignTokens.Colors.textSecondary)
            }
            Spacer()

            Button(action: { /* Like action */ }) {
                DesignSymbol.favorite.image
                    .foregroundColor(DesignTokens.Colors.fillPrimary)
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
                activeColor: DesignTokens.Colors.fillPrimary,
                inactiveColor: DesignTokens.Colors.fillPrimary.opacity(0.3)
            )

            HStack {
                Text(viewModel.formatTime(viewModel.currentTime))
                Spacer()
                Text(viewModel.formatTime(viewModel.duration))
            }
            .font(.system(size: 12, weight: .medium, design: .default))
            .foregroundColor(DesignTokens.Colors.textSecondary)
        }
    }

    var controlsView: some View {
        HStack(spacing: 40) {
            Button(action: { viewModel.skipBackward() }) {
                DesignSymbol.skipBackward.image
                    .font(.title)
            }
            .accessibilityIdentifier("player.skipBackwardButton")

            Button(action: { viewModel.togglePlayPause() }) {
                (viewModel.isPlaying ? DesignSymbol.pauseCircle : DesignSymbol.playCircle).image
                    .font(.system(size: 64))
                    .foregroundColor(DesignTokens.Colors.fillPrimary)
            }
            .accessibilityIdentifier("player.playPauseButton")

            Button(action: { viewModel.skipForward() }) {
                DesignSymbol.skipForward.image
                    .font(.title)
            }
            .accessibilityIdentifier("player.skipForwardButton")
        }
        .foregroundColor(DesignTokens.Colors.fillPrimary)
    }
    
    var secondaryActionsView: some View {
        HStack {
            Button(action: viewModel.tapOnRepeat) {
                DesignSymbol.repeatPlayback.image
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(viewModel.isOnRepeat ? DesignTokens.Colors.fillPrimary : DesignTokens.Colors.fillPrimary.opacity(0.5))
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(
                        Capsule()
                            .fill(DesignTokens.Colors.fillPrimary.opacity(0.1))
                    )
            }
            
            Spacer()
            
            Button(action: {}) {
                DesignSymbol.lyrics.image
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(DesignTokens.Colors.fillPrimary.opacity(0.5))
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(
                        Capsule()
                            .fill(DesignTokens.Colors.fillPrimary.opacity(0.1))
                    )
            }
            .disabled(true)
            
            Spacer()
            
            Button(action: {}) {
                DesignSymbol.download.image
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(DesignTokens.Colors.fillPrimary.opacity(0.5))
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(
                        Capsule()
                            .fill(DesignTokens.Colors.fillPrimary.opacity(0.1))
                    )
            }
            .disabled(true)
        }
        .padding(.horizontal, 24)
    }
}
