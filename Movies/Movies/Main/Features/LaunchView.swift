import DesignerSystem
import Scheme
import SwiftUI

struct LaunchView: View {
    typealias Strings = L10n.Localizable
    @Binding var finishLauching: Bool
    @State var letterColors: [Color] = Array(repeating: .secondaryApp, count: Strings.launchTitle.count)
    let color: Color = .secondaryApp // Letter Color
    let text = Strings.launchTitle

    var body: some View {
        ZStack {
            Color.primaryApp
                .ignoresSafeArea()

            flickerAnimation()
                .padding(.top, 170)
            VStack {
                Image.popcornFill
                    .resizable()
                    .scaledToFill()
                    .frame(width: 90, height: 100)
                    .foregroundStyle(.gray)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
                finishLauching = true
            })
        }
    }

    @ViewBuilder
    func flickerAnimation() -> some View {
        HStack(spacing: .zero) {
            ForEach(0..<text.count, id: \.self) { index in
                Text(String(text[text.index(text.startIndex, offsetBy: index)]))
                    .foregroundStyle(letterColors[index])

                // If the color of the letter is white, it will contain a shadow.
                    .shadow(color: letterColors[index] == color ? color : .clear, radius: 2)
                    .shadow(color: letterColors[index] == color ? color : .clear, radius: 50)
            }
        }
        .font(.boldApp(size: .h2))
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                changeColors()

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                    timer.invalidate()

                    letterColors = Array(repeating: color, count: text.count)
                })
            }
        }
    }

    private func changeColors() {
        for index in letterColors.indices {
            // We use random to change the color of the letters randomly.
            letterColors[index] = Bool.random() ? .gray.opacity(0.3) : color
        }
    }
}

#Preview {
    LaunchView(finishLauching: .constant(false))
}
