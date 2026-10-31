import UIKit
import SwiftUI
public final class StockTagView: UIView {
    public enum Style { case available, unavailable, pending }
    public struct Content {
        let text: String
        let style: Style
        public init(text: String, style: Style) {
            self.text = text
            self.style = style
        }
    }
    private let label = UILabel()
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        layer.cornerRadius = 8
        label.font = .preferredFont(forTextStyle: .caption1)
        label.numberOfLines = 0
        embed(label, in: self, inset: 8)
    }
    required init?(coder: NSCoder) { fatalError("Use init(frame:)") }
    public func configure(with content: Content) {
        label.text = content.text
        let color: UIColor
        switch content.style {
        case .available: color = .systemBlue
        case .unavailable: color = .secondaryLabel
        case .pending: color = .systemGray
        }
        label.textColor = color
        backgroundColor = color.withAlphaComponent(0.1)
    }
}
#Preview("Available") {
    let view = StockTagView()
    view.configure(with: .init(text: "In Stock", style: .available))
    return view
}
#Preview("Unavailable") {
    let view = StockTagView()
    view.configure(with: .init(text: "Sold Out", style: .unavailable))
    return view
}
#Preview("Pending") {
    let view = StockTagView()
    view.configure(with: .init(text: "Restocking", style: .pending))
    return view
}
