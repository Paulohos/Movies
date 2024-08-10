import SwiftUI

public enum ButtonType {
    case filled
    case outline

    var style: ButtonStyleComponents {
        switch self {
        case .filled:
            return .filled()
        case .outline:
            return .outline()
        }
    }
}

public struct MovieButton<Content: View>: View {

    private let type: ButtonType

    let action: () -> Void
    let label: () -> Content

    public init(type: ButtonType, action: @escaping () -> Void, @ViewBuilder label: @escaping () -> Content) {
        self.type = type
        self.action = action
        self.label = label
    }

    public init(type: ButtonType, action: @escaping () -> Void, title: String) where Content == Text {
        self.init(type: type, action: action, label: { Text(title) })
    }

    public init(action: @escaping () -> Void, title: String) where Content == Text {
        self.init(type: .filled, action: action, label: { Text(title) })
    }

    public init(action: @escaping () -> Void, @ViewBuilder label: @escaping () -> Content) {
        self.init(type: .filled, action: action, label: label)
    }

    public init(action: @escaping () -> Void, with: ButtonImageAndText) where Content == ButtonImageAndTextContentView {
        self.init(type: .filled, action: action, label: { ButtonImageAndTextContentView(type: with)})
    }

    public init(type: ButtonType, action: @escaping () -> Void, with: ButtonImageAndText) where Content == ButtonImageAndTextContentView {
        self.init(type: type, action: action, label: { ButtonImageAndTextContentView(type: with)})
    }

    public var body: some View {

        switch type {
        case .filled:
            Button(
                action: {
                   action()
                },
                label: label
            )
            .buttonStyle(
                FilledButtonStyle(style: type.style)
            )

        case .outline:
            Button(
                action: {
                    action()
                },
                label: label
            )
            .buttonStyle(
                OutlineButtonStyle(style: type.style)
            )
        }
    }
}

#Preview {
    VStack {
        MovieButton(action: {}, with: .imageAndText(image: Image(systemName: "plus"), text: "Title"))
        MovieButton(action: {}, with: .textEndImage(image: Image(systemName: "plus"), Text: "Title"))
        MovieButton(type: .outline, action: {}, title: "Title")
    }
    .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
    .background(.black)
}
