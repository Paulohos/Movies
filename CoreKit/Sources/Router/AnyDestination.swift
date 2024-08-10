import SwiftUI

public enum SegueOption: Equatable {
    case push
    case sheet
    case fullScreenCover
}

public struct AnyDestination: Identifiable, Hashable {
    public let id = UUID().uuidString
    public let segue: SegueOption
    public let destination: AnyView
    public var detents: Set<PresentationDetent> = [.large]
    public var selection: Binding<PresentationDetent>?

    public init<T:View>(_ segue: SegueOption, destination: T) {
        self.segue = segue
        self.destination = AnyView(destination)
    }

    public init<T:View>(_ segue: SegueOption, detents: Set<PresentationDetent> = [.large], selection: Binding<PresentationDetent>? = nil, destination: T) {
        self.segue = segue
        self.detents = detents
        self.selection = selection
        self.destination = AnyView(destination)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func == (lhs: AnyDestination, rhs: AnyDestination) -> Bool {
        lhs.id == rhs.id
    }
}
