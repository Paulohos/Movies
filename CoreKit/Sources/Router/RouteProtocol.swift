import SwiftUI

public protocol RouteProtocol {
    func showScreen<T: View>(_ option: SegueOption,  @ViewBuilder destinationView: @escaping () -> T)

    func showResizableSheet<T: View>(
        _ detents: Set<PresentationDetent>,
        showDragIndicator: Bool,
        selection: Binding<PresentationDetent>?,
        @ViewBuilder destinationView: @escaping () -> T)

    func pop()
    func popToRoot()

    func dismiss()
    func dismissPresenting()
    func dismissAllToRoot()

    var presentingSheet: Binding<AnyDestination?> { get }
    var presentingFullScreen: Binding<AnyDestination?> { get }

    func replaceNavigationStack(@DestinationBuilder path: () -> [AnyDestination])
}
