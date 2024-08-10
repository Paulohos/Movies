import SwiftUI
import SDWebImage

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        _ = Current

        // Setting disk cache
        SDImageCache.shared.config.maxMemoryCost = 1000000 * 500 // 500 MB

        // Setting memory cache
        SDImageCache.shared.config.maxDiskSize = 1000000 * 500 // 500 MB

        return true
    }
}
