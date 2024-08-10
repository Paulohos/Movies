import Foundation
import SwiftUI

struct SheetViewModifier: ViewModifier {

    let sheet: Binding<AnyDestination?>
    let sheetDetents: Set<PresentationDetent>
    @Binding var sheetSelection: PresentationDetent
    let sheetSelectionEnabled: Bool
    let showDragIndicator: Bool

    func body(content: Content) -> some View {
        content
            .sheet(item: sheet) { view in
                view.destination
                    .presentationDetentsIfNeeded(
                        sheetDetents: sheetDetents,
                        sheetSelection: $sheetSelection,
                        sheetSelectionEnabled: sheetSelectionEnabled,
                        showDragIndicator: showDragIndicator)
            }
    }
}

extension View {
    @ViewBuilder func presentationDetentsIfNeeded(
        sheetDetents: Set<PresentationDetent>,
        sheetSelection: Binding<PresentationDetent>,
        sheetSelectionEnabled: Bool,
        showDragIndicator: Bool) -> some View {
            if sheetSelectionEnabled {
                self
                    .presentationDetents(sheetDetents, selection: Binding(selection: sheetSelection))
                    .presentationDragIndicator(showDragIndicator ? .visible : .hidden)
            } else {
                self
                    .presentationDetents(sheetDetents)
                    .presentationDragIndicator(showDragIndicator ? .visible : .hidden)
            }
        }
}

private extension Binding where Value == PresentationDetent {

    init(selection: Binding<PresentationDetent>) {
        self.init {
            selection.wrappedValue
        } set: { newValue in
            selection.wrappedValue = newValue
        }
    }
}
