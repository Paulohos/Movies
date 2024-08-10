import PopularMovies
import Router
import SwiftUI

struct ContentView: View {
    @State var finishLauching: Bool = false
    var body: some View {
        if finishLauching {
            RoutingView { router in
                ListOfMoviesView.makeListOfMoviesView(router: router)
                    .animation(.easeIn, value: finishLauching)
            }
        } else {
            LaunchView(finishLauching: $finishLauching)
        }
    }
}

#Preview {
    ContentView()
}
