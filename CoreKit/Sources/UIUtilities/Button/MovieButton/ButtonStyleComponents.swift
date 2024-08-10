import SwiftUI

struct ButtonStyleComponents {
    let titleText: Color
    let titleTextHighlighted: Color
    let background: Color
    let backgroundHighlighted: Color
    let borderColor: Color
}

extension ButtonStyleComponents {
    // MARK: - Filled Style
    public static func filled() -> Self {
        .init(
            titleText: Color.primaryApp,
            titleTextHighlighted: .primaryApp.opacity(0.5),
            background: Color.secondaryApp,
            backgroundHighlighted: .secondaryApp.opacity(0.9),
            borderColor: .clear
        )
    }
    
    // MARK: - Outline Style
    public static func outline() -> Self {
        .init(
            titleText: Color.secondaryApp,
            titleTextHighlighted: Color.secondaryApp.opacity(0.5),
            background: .clear,
            backgroundHighlighted: .clear,
            borderColor: Color.secondaryApp
        )
    }
}
