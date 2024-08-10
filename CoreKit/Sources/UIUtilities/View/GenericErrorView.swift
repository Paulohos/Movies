import DesignerSystem
import Scheme
import SharedModels
import SwiftUI

public struct GenericErrorView: View {

    private let data: Data

    public init(data: Data) {
        self.data = data
    }

    public var body: some View {
        ZStack {
            Color.primaryApp
                .ignoresSafeArea(.all)

            if data.shouldDisplayDismissButton {
                VStack {
                    Button(action: {
                        data.dismiss?()
                    }) {
                        Image.xMark
                            .resizable()
                            .scaledToFit()
                            .padding(.all, 10)
                            .foregroundStyle(Color.secondaryApp)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 40, alignment: .trailing)
                    .padding(.trailing, 16)

                    Spacer()
                }
            }

            VStack(spacing: 24) {
                data.image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 120)
                    .foregroundStyle(.secondary)

                Text(data.title)
                    .font(.boldApp(size: .h5))
                    .foregroundStyle(Color.secondaryApp)
                    .multilineTextAlignment(.center)

                Text(data.subtitle)
                    .font(.regularApp(size: .body1))
                    .foregroundStyle(Color.secondaryApp)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, .paddingBig)

                if let title = data.buttonTitle {
                    MovieButton(action: {
                        data.tapFirstButton?()
                    }, title: title)
                }
            }
            .padding(.top, -50)
            .padding(.horizontal, .paddingRegular)
        }
    }
}

#Preview {
    GenericErrorView(
        data: .init(
            title: "Oops... Algo deu errado",
            subtitle: "Estamos passando por instabilidades, por favor, tente mais tarde.",
            buttonTitle: "Tentar novamente",
            shouldDisplayDismissButton: true
        )
    )
}

extension GenericErrorView {
    public struct Data {
        let title: String
        let subtitle: String
        let buttonTitle: String?
        let shouldDisplayDismissButton: Bool
        let image: Image
        var tapFirstButton: (() -> Void)?
        var dismiss: (() -> Void)?

        public init(
            title: String,
            subtitle: String,
            buttonTitle: String? = nil,
            shouldDisplayDismissButton: Bool = false,
            image: Image = .popcornFill,
            tapFirstButton: ( () -> Void)? = nil,
            dismiss: ( () -> Void)? = nil
        ) {
            self.title = title
            self.subtitle = subtitle
            self.buttonTitle = buttonTitle
            self.shouldDisplayDismissButton = shouldDisplayDismissButton
            self.image = image
            self.tapFirstButton = tapFirstButton
            self.dismiss = dismiss
        }
    }
}

extension GenericErrorView {
    public static func genericView(
        error: DefaultError,
        shouldDisplayDismissButton: Bool = false,
        action: @escaping () -> Void,
        dismiss: @escaping () -> Void = {}
    ) -> some View {
        GenericErrorView(
            data: .init(
                title: error.title,
                subtitle: error.message,
                buttonTitle: L10n.Localizable.tryAgain,
                shouldDisplayDismissButton: shouldDisplayDismissButton,
                tapFirstButton: {
                    action()
                },
                dismiss: {
                    dismiss()
                }
            )
        )
    }
}
