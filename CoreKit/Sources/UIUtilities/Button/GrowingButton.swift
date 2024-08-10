import Foundation
import SwiftUI

public struct GrowingButton: ButtonStyle {
    let scale: CGFloat

    public init(scale: CGFloat = 1.03) {
        self.scale = scale
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scale : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
