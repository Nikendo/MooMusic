import SwiftUI
import Combine

public enum MainTab: Hashable, Sendable {
    case home
    case radio
}

@MainActor
public final class MainRouter: ObservableObject {
    @Published public var selectedTab: MainTab

    public init(selectedTab: MainTab = .home) {
        self.selectedTab = selectedTab
    }
}
