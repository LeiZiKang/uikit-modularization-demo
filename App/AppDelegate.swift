import UIKit
@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        let arguments = ProcessInfo.processInfo.arguments
        let index = arguments.firstIndex(of: "-scene").map { $0 + 1 }
        let scene = index.flatMap { arguments.indices.contains($0) ? ProductScene(rawValue: arguments[$0]) : nil }
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = ProductDetailViewController(scene: scene ?? .inStock)
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}
