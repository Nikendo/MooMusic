import SwiftUI

public struct DesignSymbol: Sendable {
    public var image: Image {
        Image(systemName: systemName)
    }

    private let systemName: String

    private init(systemName: String) {
        self.systemName = systemName
    }

    public static let home = DesignSymbol(systemName: "music.note.house.fill")
    public static let radio = DesignSymbol(systemName: "dot.radiowaves.left.and.right")
    public static let play = DesignSymbol(systemName: "play.fill")
    public static let pause = DesignSymbol(systemName: "pause.fill")
    public static let playCircle = DesignSymbol(systemName: "play.circle.fill")
    public static let pauseCircle = DesignSymbol(systemName: "pause.circle.fill")
    public static let dismiss = DesignSymbol(systemName: "chevron.down")
    public static let favorite = DesignSymbol(systemName: "heart")
    public static let skipBackward = DesignSymbol(systemName: "backward.fill")
    public static let skipForward = DesignSymbol(systemName: "forward.fill")
    public static let repeatPlayback = DesignSymbol(systemName: "repeat")
    public static let lyrics = DesignSymbol(systemName: "text.alignleft")
    public static let download = DesignSymbol(systemName: "arrow.down.circle")
}
