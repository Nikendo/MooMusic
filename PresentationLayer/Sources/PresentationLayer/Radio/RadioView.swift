import SwiftUI

public struct RadioView: View {
    public init() {}

    public var body: some View {
        NavigationStack {
            VStack {
                Text("Radio screen")
                Text("In development")
            }
            .navigationTitle("Radio")
        }
    }
}
