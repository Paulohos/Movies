import PopularMovies
import Router
import SwiftUI

@main
struct MoviesApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            RoutingView { router in
                ListOfMoviesView.makeListOfMoviesView(router: router)
            }
        }
    }
}
