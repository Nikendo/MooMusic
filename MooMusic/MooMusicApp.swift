//
//  MooMusicApp.swift
//  MooMusic
//

import SwiftUI
import PresentationLayer

@main
struct MooMusicApp: App {
    private let container = DependencyContainer.shared

    var body: some Scene {
        WindowGroup {
            AppRootView(coordinator: container.appCoordinator)
        }
    }
}
