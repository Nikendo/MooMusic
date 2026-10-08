import SwiftUI

public struct RadioView: View {
    public init() {}

    public var body: some View {
        NavigationStack {
            VStack {
                Strings.radioScreen
                Strings.radioInDevelopment
            }
            .navigationTitle(Strings.radioNavigationTitle)
        }
    }
}
