import SwiftUI
import Kingfisher

enum PlayerAlbumCoverGeometry {
    static let id = "player.albumCover"
    static let miniSide: CGFloat = 40
    static let fullSide: CGFloat = 320
    static let cornerRadius: CGFloat = 12
    static let animation: Animation = .spring(response: 0.48, dampingFraction: 0.86)
}

enum PlayerAlbumCoverSlot {
    case mini
    case full

    var side: CGFloat {
        switch self {
        case .mini:
            PlayerAlbumCoverGeometry.miniSide
        case .full:
            PlayerAlbumCoverGeometry.fullSide
        }
    }

    func isSource(isExpanded: Bool) -> Bool {
        switch self {
        case .mini:
            !isExpanded
        case .full:
            isExpanded
        }
    }
}

private struct IsPlayerExpandedKey: EnvironmentKey {
    static let defaultValue = false
}

extension EnvironmentValues {
    var isPlayerExpanded: Bool {
        get { self[IsPlayerExpandedKey.self] }
        set { self[IsPlayerExpandedKey.self] = newValue }
    }
}

struct PlayerAlbumCoverAnchor: View {
    @Environment(\.isPlayerExpanded) private var isPlayerExpanded

    let namespace: Namespace.ID
    let slot: PlayerAlbumCoverSlot

    var body: some View {
        Color.clear
            .frame(width: slot.side, height: slot.side)
            .matchedGeometryEffect(
                id: PlayerAlbumCoverGeometry.id,
                in: namespace,
                isSource: slot.isSource(isExpanded: isPlayerExpanded)
            )
            .geometryGroup()
            .allowsHitTesting(false)
            .accessibilityHidden(true)
    }
}

struct PlayerAlbumCoverHero: View {
    @Environment(\.isPlayerExpanded) private var isPlayerExpanded

    let url: URL?
    let namespace: Namespace.ID
    let onArtworkLoaded: (UIImage) -> Void

    private var side: CGFloat {
        isPlayerExpanded ? PlayerAlbumCoverGeometry.fullSide : PlayerAlbumCoverGeometry.miniSide
    }

    var body: some View {
        KFImage(url)
            .placeholder {
                Color.gray.opacity(0.3)
            }
            .onSuccess { result in
                onArtworkLoaded(result.image)
            }
            .onFailure { error in
                print("Loading artwork error: \(error.localizedDescription)")
            }
            .fade(duration: 0)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: side, height: side)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: PlayerAlbumCoverGeometry.cornerRadius,
                    style: .continuous
                )
            )
            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 10)
            .matchedGeometryEffect(
                id: PlayerAlbumCoverGeometry.id,
                in: namespace,
                isSource: false
            )
            .geometryGroup()
            .allowsHitTesting(false)
            .accessibilityHidden(true)
    }
}
