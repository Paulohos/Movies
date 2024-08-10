import SwiftUI
import Combine

public struct RoutingView<Content: View>: View {

    private let content: (AnyRouter) -> Content

    // Sheet presentation configuration
    @State var sheetSelection: Binding<PresentationDetent> = .constant(.large)
    @State private var sheetDetents: Set<PresentationDetent> = [.large]
    @State private var showDragIndicator: Bool = true
    @State private var sheetSelectionEnabled: Bool = false

    // Navigation Flow
    @State private var navigationPath: [AnyDestination] = []
    @State private var presentedSheet: AnyDestination? = nil
    @State private var presentedFullScreen: AnyDestination? = nil
    @State private var presentingModal: AnyDestination? = nil
    @Binding var isPresented: AnyDestination?

    var isPresenting: Bool {
        presentedSheet != nil || presentedFullScreen != nil || presentingModal != nil
    }



    public init(_ isPresented: Binding<AnyDestination?> = .constant(nil), @ViewBuilder content: @escaping (AnyRouter) -> Content) {
        self.content = content
        self._isPresented = isPresented
    }

    public var body: some View {
        NavigationStack(path: $navigationPath) {
            content(AnyRouter(router: self))
                .navigationDestination(for: AnyDestination.self) { destination in
                    destination.destination
                }
        }
        .modifier(
            SheetViewModifier(
                sheet: $presentedSheet,
                sheetDetents: sheetDetents,
                sheetSelection: sheetSelection,
                sheetSelectionEnabled: sheetSelectionEnabled,
                showDragIndicator: showDragIndicator
            )
        )
        .fullScreenCover(item: $presentedFullScreen) { destination in
            destination.destination
        }.modal(item: $presentingModal) { destination in
            destination.destination
        }
    }
}

extension RoutingView: RouteProtocol {
    public var presentingSheet: Binding<AnyDestination?> {
        $presentedSheet
    }

    public var presentingFullScreen: Binding<AnyDestination?> {
        $presentedFullScreen
    }

    public func showScreen<T>(_ option: SegueOption, destinationView: @escaping () -> T) where T : View {
        switch option {
        case .push:
            navigationPath.append(.init(option, destination: destinationView()))
        case .sheet:
            sheetSelection = .constant(.large)
            sheetDetents = [.large]
            presentedSheet = .init(option, destination: destinationView())
        case .fullScreenCover:
            presentedFullScreen = .init(option, destination: destinationView())
        }
    }

    public func showResizableSheet<T>(
        _ detents: Set<PresentationDetent>,
        showDragIndicator: Bool,
        selection: Binding<PresentationDetent>?,
        destinationView: @escaping () -> T
    ) where T : View {
        if let selection {
            sheetSelection = selection
            sheetSelectionEnabled = true
        } else {
            sheetSelectionEnabled = false
        }

        self.sheetDetents = detents
        self.showDragIndicator = showDragIndicator

        presentedSheet = .init(.sheet, detents: detents, selection: selection, destination: destinationView())
    }

    public func pop() {
        guard !navigationPath.isEmpty else { return }

        navigationPath.removeLast()
    }

    public func popToRoot() {
        navigationPath = []
    }

    public func dismiss() {
        if presentedSheet != nil {
            presentedSheet = nil
        } else if presentedFullScreen != nil {
            presentedFullScreen = nil
        } else if presentingModal != nil {
            presentingModal = nil
        } else if navigationPath.count > 1 {
            navigationPath.removeLast()
        } else {
            isPresented = nil
        }
    }

    public func dismissPresenting() {
        presentedSheet = nil
        presentedFullScreen = nil
        presentingModal = nil
        isPresented = nil
    }

    public func dismissAllToRoot() {
        popToRoot()
        dismissPresenting()
    }

    public func replaceNavigationStack(@DestinationBuilder path: () -> [AnyDestination]) {
        navigationPath = path()
    }
}
