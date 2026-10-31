import UIKit
import DevTools

@main
@MainActor
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    // Fake registration state only. No network interception is installed.
    private var mocksRegistered = false
    private lazy var devTools = DevTools(
        enqueueAlert: { presenter, text in
            let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            presenter.present(alert, animated: true)
        },
        registerMocks: { [weak self] in self?.mocksRegistered = true }
    )

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        devTools.start()
        let args = ProcessInfo.processInfo.arguments
        let scene: PreviewScene
        if let index = args.firstIndex(of: "-scene"), args.indices.contains(index + 1) {
            scene = PreviewScene(rawValue: args[index + 1]) ?? .success
        } else {
            scene = .success
        }
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = ItemViewController(api: FixtureItemAPI(scene: scene))
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}
