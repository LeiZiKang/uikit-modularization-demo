import UIKit
import SwiftUI
public final class PurchaseBarView: UIView {
    public struct Content {
        let button: BuyButton.Content
        let note: String?
        public init(button: BuyButton.Content, note: String? = nil) {
            self.button = button
            self.note = note
        }
    }
    public var onTap: (() -> Void)?
    private let button = BuyButton()
    private let note = UILabel()
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 16
        note.font = .preferredFont(forTextStyle: .footnote)
        note.textColor = .secondaryLabel
        note.textAlignment = .center
        note.numberOfLines = 0
        embed(column([button, note], spacing: 8), in: self, inset: 16)
        button.onTap = { [weak self] in self?.onTap?() }
    }
    required init?(coder: NSCoder) { fatalError("Use init(frame:)") }
    public func configure(with content: Content) {
        button.configure(with: content.button)
        note.text = content.note
        note.isHidden = content.note == nil
    }
}
#Preview("Purchase Note") {
    let view = PurchaseBarView()
    view.configure(with: .init(button: .init(title: "Sold Out", isEnabled: false),
                              note: "This item won't be restocked."))
    return view
}
