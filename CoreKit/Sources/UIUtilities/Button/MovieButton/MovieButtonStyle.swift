import DesignerSystem
import SwiftUI

// MARK: - Filled Style
struct FilledButtonStyle: ButtonStyle {
    var style: ButtonStyleComponents
    
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .font(.boldApp(size: .button))
            .padding()
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .background(
                Group {
                    if configuration.isPressed {
                        ZStack {
                            style.backgroundHighlighted
                        }

                    } else {
                        style.background
                    }
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: .roundedCorderExtraSmall))
            .foregroundColor(
                configuration.isPressed
                ? style.titleTextHighlighted
                : style.titleText
            )

    }
}

// MARK: - Outline Style
struct OutlineButtonStyle: ButtonStyle {
    var style: ButtonStyleComponents

    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .font(.boldApp(size: .button))
            .padding()
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .foregroundColor(
                configuration.isPressed
                ? style.titleTextHighlighted
                : style.titleText
            )
            .background(
                RoundedRectangle(cornerRadius: .roundedCorderExtraSmall)
                    .stroke(
                        style.borderColor,
                        lineWidth: 1.5
                    )
            )
    }
}
