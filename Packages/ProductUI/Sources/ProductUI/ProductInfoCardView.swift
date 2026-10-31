import UIKit
import SwiftUI
public final class ProductInfoCardView: UIView {
    public struct Content {
        let title: String
        let subtitle: String
        let price: PriceView.Content
        let stockTag: StockTagView.Content
        public init(title: String, subtitle: String, price: PriceView.Content, stockTag: StockTagView.Content) {
            self.title = title
            self.subtitle = subtitle
            self.price = price
            self.stockTag = stockTag
        }
    }
    private let title = UILabel()
    private let subtitle = UILabel()
    private let price = PriceView()
    private let stockTag = StockTagView()
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        title.font = .preferredFont(forTextStyle: .title1)
        subtitle.font = .preferredFont(forTextStyle: .subheadline)
        subtitle.textColor = .secondaryLabel
        [title, subtitle].forEach { $0.numberOfLines = 0 }
        let stack = column([title, subtitle, price, stockTag])
        stack.alignment = .leading
        embed(stack, in: self)
    }
    required init?(coder: NSCoder) { fatalError("Use init(frame:)") }
    public func configure(with content: Content) {
        title.text = content.title
        subtitle.text = content.subtitle
        price.configure(with: content.price)
        stockTag.configure(with: content.stockTag)
    }
}
#Preview("Product Info") {
    let view = ProductInfoCardView()
    view.configure(with: .init(title: "Canvas Tote", subtitle: "Natural / Everyday collection",
                              price: .init(priceText: "$28.00", originalPriceText: "$36.00"),
                              stockTag: .init(text: "In Stock", style: .available)))
    return view
}
