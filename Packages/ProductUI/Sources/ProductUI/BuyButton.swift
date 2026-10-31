import UIKit
import SwiftUI
public final class BuyButton: UIButton {
    public struct Content {
        let title: String
        let isEnabled: Bool
        public init(title: String, isEnabled: Bool) {
            self.title = title
            self.isEnabled = isEnabled
        }
    }
    public var onTap: (() -> Void)?
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        configuration = .filled()
        configuration?.baseBackgroundColor = .systemBlue
        configuration?.cornerStyle = .medium
        configuration?.contentInsets = .init(top: 15, leading: 24, bottom: 15, trailing: 24)
        addAction(UIAction { [weak self] _ in self?.onTap?() }, for: .touchUpInside)
    }
    required init?(coder: NSCoder) { fatalError("Use init(frame:)") }
    public func configure(with content: Content) {
        configuration?.title = content.title
        isEnabled = content.isEnabled
    }
}
#Preview("Enabled") {
    let view = BuyButton()
    view.configure(with: .init(title: "Add to Cart", isEnabled: true))
    return view
}
#Preview("Disabled") {
    let view = BuyButton()
    view.configure(with: .init(title: "Sold Out", isEnabled: false))
    return view
}
