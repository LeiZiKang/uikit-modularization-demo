import UIKit
import SwiftUI
public final class PriceView: UIView {
    public struct Content {
        let priceText: String
        let originalPriceText: String?
        public init(priceText: String, originalPriceText: String? = nil) {
            self.priceText = priceText
            self.originalPriceText = originalPriceText
        }
    }
    private let price = UILabel()
    private let original = UILabel()
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        price.font = .preferredFont(forTextStyle: .title2)
        original.font = .preferredFont(forTextStyle: .subheadline)
        original.textColor = .secondaryLabel
        let row = UIStackView(arrangedSubviews: [price, original])
        row.spacing = 10
        row.alignment = .firstBaseline
        embed(row, in: self)
    }
    required init?(coder: NSCoder) { fatalError("Use init(frame:)") }
    public func configure(with content: Content) {
        price.text = content.priceText
        original.isHidden = content.originalPriceText == nil
        original.attributedText = content.originalPriceText.map {
            NSAttributedString(string: $0, attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
        }
    }
}
#Preview("Original Price") {
    let view = PriceView()
    view.configure(with: .init(priceText: "$28.00", originalPriceText: "$36.00"))
    return view
}
