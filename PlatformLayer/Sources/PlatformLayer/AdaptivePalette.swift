import SwiftUI

public struct AdaptivePalette: Equatable, Sendable {
    public let background: Color
    public let primaryText: Color
    public let secondaryText: Color
    public let accent: Color

    public static let `default` = AdaptivePalette(
        background: .black,
        primaryText: .white,
        secondaryText: .white.opacity(0.7),
        accent: .yellow
    )
}
