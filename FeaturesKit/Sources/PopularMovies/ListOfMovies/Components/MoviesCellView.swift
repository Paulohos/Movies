import SDWebImageSwiftUI
import SwiftUI
import UIUtilities

struct MoviesCellView: View {

    private let urlImage: URL?
    private let action: () -> Void

    init(urlImage: URL?, action: @escaping () -> Void) {
        self.urlImage = urlImage
        self.action = action
    }
    var body: some View {
        Button(
            action: { action() },
            label: {
                WebImage(url: urlImage) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Rectangle()
                        .foregroundColor(.gray.opacity(0.3))
                }
                .indicator(content: { isAnimating, progress in
                    ProgressView()
                        .tint(.white)
                })
                .transition(.fade(duration: 0.5)) // Fade Transition with duration
            })
        .buttonStyle(GrowingButton())
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .fadeOffsetAnimationCard()
    }
}

#Preview {
    MoviesCellView(
        urlImage: .init(
            string: "https://image.tmdb.org/t/p/w500/9l1eZiJHmhr5jIlthMdJN5WYoff.jpg"),
        action: {}
    )
}
