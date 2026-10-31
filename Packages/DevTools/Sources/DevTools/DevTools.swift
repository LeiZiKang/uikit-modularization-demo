import UIKit

@MainActor
public final class DevTools {
    private let enqueueAlert: (UIViewController, String) -> Void
    private let registerMocks: () -> Void

    public init(
        enqueueAlert: @escaping (UIViewController, String) -> Void,
        registerMocks: @escaping () -> Void = {}
    ) {
        self.enqueueAlert = enqueueAlert
        self.registerMocks = registerMocks
    }

    public func start() {
        #if DEBUG
        registerMocks()
        #endif
    }

    public func showMessage(_ text: String, from presenter: UIViewController) {
        enqueueAlert(presenter, text)
    }
}
