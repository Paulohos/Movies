import SwiftUI

struct FadeOffsetAnimationCard: ViewModifier {
    @State var startAnimation: Bool = false

    func body(content: Content) -> some View {
        content
            .opacity(startAnimation ? 1 : 0.0)
            .offset(x: 0, y: startAnimation ? 10.0 : -10)
            .animation(.easeInOut(duration: 0.5).delay(0.2), value: startAnimation)
            .onAppear {
                startAnimation = true
            }
    }
}
public extension View {
    func fadeOffsetAnimationCard() -> some View {
        modifier(FadeOffsetAnimationCard())
    }
}
