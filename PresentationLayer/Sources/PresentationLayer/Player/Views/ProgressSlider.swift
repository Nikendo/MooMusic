import SwiftUI

public struct ProgressSlider: View {
    @Binding var value: Double
    var range: ClosedRange<Double>
    @Binding var isScrubbing: Bool
    var onEditingChanged: () -> Void

    var activeColor: Color = .yellow
    var inactiveColor: Color = .white.opacity(0.3)

    public var body: some View {
        GeometryReader { geometry in
            let percent = max(
                0,
                min(1, (value - range.lowerBound) / (range.upperBound - range.lowerBound))
            )

            ZStack(alignment: .leading) {
                Capsule()
                    .fill(inactiveColor)
                    .frame(height: 4)

                Capsule()
                    .fill(activeColor)
                    .frame(width: geometry.size.width * CGFloat(percent), height: 4)

                Rectangle()
                    .fill(Color.green.opacity(0.3))
                    .frame(height: 30)
                    .contentShape(.rect)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { drag in
                                isScrubbing = true
                                let dragX = max(0, min(drag.location.x, geometry.size.width))
                                let newPercent = dragX / geometry.size.width
                                value = range.lowerBound + Double(newPercent) * (range.upperBound - range.lowerBound)
                            }
                            .onEnded{ drag in
                                isScrubbing = false
                                onEditingChanged()
                            }
                    )
            }
        }
        .frame(height: 30)
    }
}

#Preview {
    ZStack {
        if #available(iOS 18.0, *) {
            Color.black.mix(with: .gray, by: 0.5)
                .ignoresSafeArea()
        } else {
            Color.black
                .ignoresSafeArea()
        }
        ProgressSlider(
            value: .constant(40),
            range: 0.0...120.0,
            isScrubbing: .constant(false),
            onEditingChanged: {}
        )
    }
}
