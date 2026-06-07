import Foundation

public protocol ColorExtractorServiceProtocol: Sendable {
    func extractDominantColor(from imageData: Data) async -> DominantColor?
}
