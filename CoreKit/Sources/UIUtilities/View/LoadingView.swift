import DesignerSystem
import Lottie
import SwiftUI

public struct LoadingView: View {

    public init() {}

    public var body: some View {
        ZStack {
            Color.primaryApp
                .ignoresSafeArea()

            LottieView(animation: .named("loadingfile"))
                .looping()
                .frame(maxWidth: 100)
        }
    }
}

#Preview {
    LoadingView()
}
