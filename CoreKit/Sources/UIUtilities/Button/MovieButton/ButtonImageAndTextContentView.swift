import SwiftUI

public enum ButtonImageAndText {
    case imageAndText(image: Image,text: String)
    case textEndImage(image: Image, Text: String)
}

public struct ButtonImageAndTextContentView: View {
    var type: ButtonImageAndText
    
    public var body: some View {
        
        switch type {
        case let .imageAndText( image, text):
            HStack {
                image
                Text(text)
            }
        case let .textEndImage(image, text):
            HStack {
                Text(text)
                image
            }
        }
    }
}

#Preview {
    ButtonImageAndTextContentView(type: .imageAndText(image: Image(systemName: "plus"), text: "title"))
}
