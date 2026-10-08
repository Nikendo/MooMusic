import SwiftUI

enum Strings {
    static var homeScreen: Text { text("home.screen") }
    static var homePlayDemo: Text { text("home.playDemo") }
    static var homeNavigationTitle: Text { text("home.navigationTitle") }

    static var radioScreen: Text { text("radio.screen") }
    static var radioInDevelopment: Text { text("radio.inDevelopment") }
    static var radioNavigationTitle: Text { text("radio.navigationTitle") }

    static var tabHome: Text { text("tab.home") }
    static var tabRadio: Text { text("tab.radio") }

    static var playerVibe: Text { text("player.vibe") }
    static var playerLoading: String { string("player.loading") }
    static var playerUnknownArtist: String { string("player.unknownArtist") }

    static var trackNotFound: String { string("error.trackNotFound") }

    static func networkError(_ description: String) -> String {
        String(format: string("error.network"), locale: .current, description)
    }

    private static func text(_ key: LocalizedStringKey) -> Text {
        Text(key, bundle: .module)
    }

    private static func string(_ key: String.LocalizationValue) -> String {
        String(localized: key, bundle: .module)
    }
}
