import SwiftUI
import DomainLayer

public struct PlayerView: View {
    @StateObject private var viewModel: PlayerViewModel

    public init(viewModel: PlayerViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        ZStack {
            Color(red: 0.55, green: 0.45, blue: 0.3)
                .ignoresSafeArea()

            VStack(spacing: 32) {
                headerView
                albumCoverView

                VStack(spacing: 24) {
                    metadataView
                    progressView
                    controlsView
                }
                .padding(.horizontal, 24)

                Spacer()
            }
        }
        .task {
            await viewModel.fetchAndPlayTrack(query: "Soda Island")
        }
    }
}

private extension PlayerView {
    var headerView: some View {
        Text("My vibe")
            .font(.headline)
            .foregroundColor(.white)
            .padding(.top, 16)
    }

    var albumCoverView: some View {
        AsyncImage(url: viewModel.currentTrack?.coverURL) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(12)
                    .shadow(radius: 10)
            } else if phase.error != nil {
                Color.red
            } else {
                Color.gray.opacity(0.3)
            }
        }
        .frame(width: 320, height: 320)
        .padding(.top, 20)
    }

    var metadataView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.currentTrack?.title ?? "Loading...")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text(viewModel.currentTrack?.artist ?? "Artist")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }
            Spacer()

            Button(action: { /* Like action */ }) {
                Image(systemName: "heart")
                    .foregroundColor(.white)
            }
        }
    }

    var progressView: some View {
        VStack(spacing: 8) {
            Slider(value: Binding(
                get: { viewModel.currentTime },
                set: { newValue in viewModel.seek(to: newValue) }
            ), in: 0...(viewModel.duration > 0 ? viewModel.duration : 1))
            .accentColor(.yellow)

            HStack {
                Text(viewModel.formatTime(viewModel.currentTime))
                Spacer()
                Text(viewModel.formatTime(viewModel.duration))
            }
            .font(.caption)
            .foregroundColor(.white.opacity(0.7))
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
                    .foregroundColor(.yellow) // Та самая желтая кнопка
            }

            Button(action: { viewModel.skipForward() }) {
                Image(systemName: "forward.fill")
                    .font(.title)
            }
        }
        .foregroundColor(.white)
    }
}
