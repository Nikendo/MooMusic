import SwiftUI
import DomainLayer

public struct AdaptivePalette: Equatable, Sendable {
    public let background: Color
    public let primaryText: Color
    public let secondaryText: Color
    public let accent: Color

    public init(
        background: Color,
        primaryText: Color,
        secondaryText: Color,
        accent: Color
    ) {
        self.background = background
        self.primaryText = primaryText
        self.secondaryText = secondaryText
        self.accent = accent
    }

    public static let `default` = AdaptivePalette(
        background: .black,
        primaryText: .white,
        secondaryText: .white.opacity(0.7),
        accent: .yellow
    )
}

public extension AdaptivePalette {
    static func from(color: DominantColor) -> AdaptivePalette {
        let (hue, saturation, brightness) = hsbComponents(from: color)
        let isLight = brightness > 0.6

        let primaryTextBrightness = isLight ? max(0.1, brightness - 0.7) : min(0.95, brightness + 0.7)
        let primaryText = Color(
            hue: hue,
            saturation: min(saturation, 0.3),
            brightness: primaryTextBrightness
        )

        let secondaryTextBrightness = isLight ? max(0.3, brightness - 0.5) : min(0.8, brightness + 0.5)
        let secondaryText = Color(
            hue: hue,
            saturation: min(saturation, 0.4),
            brightness: secondaryTextBrightness,
            opacity: 0.8
        )

        let accentBrightness = isLight ? max(0.3, brightness - 0.4) : min(1.0, brightness + 0.3)
        let accentSaturation = min(1.0, saturation + 0.6)
        let accent = Color(
            hue: hue,
            saturation: accentSaturation,
            brightness: accentBrightness
        )

        return AdaptivePalette(
            background: Color(
                red: color.red,
                green: color.green,
                blue: color.blue,
                opacity: color.alpha
            ),
            primaryText: primaryText,
            secondaryText: secondaryText,
            accent: accent
        )
    }

    private static func hsbComponents(from color: DominantColor) -> (hue: Double, saturation: Double, brightness: Double) {
        let red = Double(color.red)
        let green = Double(color.green)
        let blue = Double(color.blue)

        let maxValue = max(red, green, blue)
        let minValue = min(red, green, blue)
        let delta = maxValue - minValue

        var hue: Double = 0
        if delta != 0 {
            if maxValue == red {
                hue = ((green - blue) / delta).truncatingRemainder(dividingBy: 6)
            } else if maxValue == green {
                hue = ((blue - red) / delta) + 2
            } else {
                hue = ((red - green) / delta) + 4
            }
            hue /= 6
            if hue < 0 {
                hue += 1
            }
        }

        let saturation = maxValue == 0 ? 0.0 : delta / maxValue
        return (hue, saturation, maxValue)
    }
}
