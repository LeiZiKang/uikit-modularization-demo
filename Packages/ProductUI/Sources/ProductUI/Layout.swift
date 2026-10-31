import UIKit
func column(_ views: [UIView], spacing: CGFloat = 12) -> UIStackView {
    let stack = UIStackView(arrangedSubviews: views)
    stack.axis = .vertical
    stack.spacing = spacing
    return stack
}
func embed(_ child: UIView, in parent: UIView, inset: CGFloat = 0) {
    child.translatesAutoresizingMaskIntoConstraints = false
    parent.addSubview(child)
    NSLayoutConstraint.activate([
        child.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: inset),
        child.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -inset),
        child.topAnchor.constraint(equalTo: parent.topAnchor, constant: inset),
        child.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -inset)
    ])
}
