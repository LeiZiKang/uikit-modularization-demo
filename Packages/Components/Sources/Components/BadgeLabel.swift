import UIKit

public final class BadgeLabel: UIView {
    public struct Configuration {
        public let text: String
        public let color: UIColor

        public init(text: String, color: UIColor) {
            self.text = text
            self.color = color
        }
    }

    private let label = UILabel()

    public init(configuration: Configuration) {
        super.init(frame: .zero)
        label.font = .preferredFont(forTextStyle: .caption1)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        layer.cornerRadius = 8
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
        apply(configuration)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("Use init(configuration:)") }

    public func apply(_ configuration: Configuration) {
        label.text = configuration.text
        label.textColor = configuration.color
        backgroundColor = configuration.color.withAlphaComponent(0.12)
        accessibilityLabel = configuration.text
        isAccessibilityElement = true
    }
}

