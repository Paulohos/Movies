import SwiftUI

public struct AnyRouter: Identifiable, RouteProtocol {
    public let id = UUID().uuidString
    public let router: RouteProtocol

    public var presentingSheet: Binding<AnyDestination?> {
        router.presentingSheet
    }

    public var presentingFullScreen: Binding<AnyDestination?> {
        router.presentingFullScreen
    }

    public func showScreen<T>(_ option: SegueOption, destinationView: @escaping () -> T) where T: View {
        router.showScreen(option, destinationView: destinationView)
    }

    public func showResizableSheet<T>(_ detents: Set<PresentationDetent>, showDragIndicator: Bool, selection: Binding<PresentationDetent>?, destinationView: @escaping () -> T) where T: View {
        router.showResizableSheet(detents, showDragIndicator: showDragIndicator, selection: selection, destinationView: destinationView)
    }

    public func pop() {
        router.pop()
    }

    public func popToRoot() {
        router.popToRoot()
    }

    public func dismiss() {
        router.dismiss()
    }

    public func dismissPresenting() {
        router.dismissPresenting()
    }

    public func dismissAllToRoot() {
        router.dismissAllToRoot()
    }

    public func replaceNavigationStack(@DestinationBuilder path: () -> [AnyDestination]) {
        router.replaceNavigationStack(path: path)
    }
}

public struct DestinationBuildData {
    let segue: SegueOption
    let destination: AnyView

    public init(segue: SegueOption, destination: AnyView) {
        self.segue = segue
        self.destination = destination
    }
}

@resultBuilder
public struct DestinationBuilder {
    public static func buildBlock(_ blocks: DestinationBuildData...) -> [AnyDestination] {
        blocks.map {AnyDestination($0.segue, destination: $0.destination)}
    }
}
