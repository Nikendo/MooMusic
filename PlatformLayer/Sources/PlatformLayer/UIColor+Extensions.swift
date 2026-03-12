import UIKit
import SwiftUI

public extension UIColor {
    func generateAdaptivePalette() -> AdaptivePalette {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        getHue(&h, saturation: &s, brightness: &b, alpha: &a)

        let isLight = b > 0.6

        let primaryTextBrightness = isLight ? max(0.1, b - 0.7) : min(0.95, b + 0.7)
        let primaryText = UIColor(
            hue: h,
            saturation: min(s, 0.3),
            brightness: primaryTextBrightness,
            alpha: 1.0
        )

        let secondaryTextBrightness = isLight ? max(0.3, b - 0.5) : min(0.8, b + 0.5)
        let secondaryText = UIColor(
            hue: h,
            saturation: min(s, 0.4),
            brightness: secondaryTextBrightness,
            alpha: 0.8
        )

        let accentBrightness = isLight ? max(0.3, b - 0.4) : min(1.0, b + 0.3)
        let accentSaturation = min(1.0, s + 0.6)
        let accent = UIColor(
            hue: h,
            saturation: accentSaturation,
            brightness: accentBrightness,
            alpha: 1.0
        )

        return AdaptivePalette(
            background: Color(self),
            primaryText: Color(primaryText),
            secondaryText: Color(secondaryText),
            accent: Color(accent)
        )
    }
}
