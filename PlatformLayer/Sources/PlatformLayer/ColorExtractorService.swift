import UIKit
import CoreImage
import Combine

public final class ColorExtractorService: Sendable {
    private let context: CIContext

    public init() {
        self.context = if let device = MTLCreateSystemDefaultDevice() {
            CIContext(mtlDevice: device)
        } else {
            CIContext(options: nil)
        }
    }

    public func extractDominantColor(from image: UIImage) async -> UIColor? {
        let ciImage: CIImage

        if let cgImage = image.cgImage {
            ciImage = CIImage(cgImage: cgImage)
        } else if let ciImg = image.ciImage {
            ciImage = ciImg
        } else {
            return nil
        }

        let extent = ciImage.extent
        let filter = CIFilter(
            name: "CIAreaAverage",
            parameters: [
                kCIInputImageKey: ciImage,
                kCIInputExtentKey: CIVector(cgRect: extent)
            ]
        )

        guard let outputImage = filter?.outputImage else { return nil }
        var bitmap = [UInt8](repeating: 0, count: 4) // rgba

        context.render(
            outputImage,
            toBitmap: &bitmap,
            rowBytes: 4,
            bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
            format: .RGBA8,
            colorSpace: CGColorSpaceCreateDeviceRGB()
        )

        return UIColor(
            red: CGFloat(bitmap[0]) / 255.0,
            green: CGFloat(bitmap[1]) / 255.0,
            blue: CGFloat(bitmap[2]) / 255.0,
            alpha: CGFloat(bitmap[3]) / 255.0
        )
    }
}
