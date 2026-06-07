import SwiftUI
#if canImport(UIKit)
import UIKit

public struct AdaptiveBackgroundView: View {
    let image: UIImage?

    public init(image: UIImage?) {
        self.image = image
    }

    public var body: some View {
        Color(hex: "#121212")
            .overlay {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .saturation(0.5)
                        .blur(radius: 60, opaque: true)
                        .overlay(Color.black.opacity(0.4))
                        .transition(.opacity.animation(.easeInOut(duration: 0.5)))
                }
            }
            .clipped()
    }
}
#endif
