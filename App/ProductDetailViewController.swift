import UIKit
import SwiftUI
import ProductUI
final class ProductDetailViewController: UIViewController {
    private let viewModel: ProductDetailViewModel
    private let info = ProductInfoCardView()
    private let purchase = PurchaseBarView()
    private var shouldBuyOnAppearance: Bool
    init(scene: ProductScene) {
        viewModel = ProductDetailViewModel(loader: ProductFixture(scene: scene))
        shouldBuyOnAppearance = scene == .apiError
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("Use init(scene:)") }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let scroll = UIScrollView()
        let image = UIImageView(image: UIImage(systemName: "bag.fill"))
        image.contentMode = .center
        image.preferredSymbolConfiguration = .init(pointSize: 88, weight: .light)
        image.tintColor = .systemGray
        image.backgroundColor = .secondarySystemBackground
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
        let description = UILabel()
        description.text = "Made for the everyday"
            + "\n\nA roomy cotton canvas tote for your daily essentials. Soft handles, a handy inner pocket, and a simple shape that goes anywhere."
            + "\n\nDETAILS\n100% cotton canvas · Natural\n38 × 40 cm · Inside pocket"
        description.font = .preferredFont(forTextStyle: .body)
        description.textColor = .secondaryLabel
        description.numberOfLines = 0
        let stack = UIStackView(arrangedSubviews: [image, info, description])
        stack.axis = .vertical
        stack.spacing = 28
        [scroll, purchase].forEach { view.addSubview($0) }
        scroll.addSubview(stack)
        [scroll, stack, purchase].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        let safe = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: safe.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: purchase.topAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 20),
            stack.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -24),
            stack.leadingAnchor.constraint(equalTo: scroll.contentLayoutGuide.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: scroll.contentLayoutGuide.trailingAnchor, constant: -24),
            stack.widthAnchor.constraint(equalTo: scroll.frameLayoutGuide.widthAnchor, constant: -48),
            image.heightAnchor.constraint(equalTo: image.widthAnchor, multiplier: 0.78),
            purchase.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 16),
            purchase.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -16),
            purchase.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -8)
        ])
        purchase.onTap = { [weak self] in self?.viewModel.buyTapped() }
        viewModel.onStateChange = { [weak self] state in
            guard let self else { return }
            self.info.configure(with: state.info)
            self.purchase.configure(with: state.purchase)
            if let message = state.errorMessage {
                let alert = UIAlertController(title: "Couldn't add to cart", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        }
        viewModel.load()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if shouldBuyOnAppearance {
            shouldBuyOnAppearance = false
            viewModel.buyTapped()
        }
    }
}
#Preview("In Stock") { ProductDetailViewController(scene: .inStock) }
#Preview("Sold Out") { ProductDetailViewController(scene: .soldOut) }
#Preview("Out of Stock") { ProductDetailViewController(scene: .outOfStock) }
#Preview("Restocking") { ProductDetailViewController(scene: .restocking) }
#Preview("API Error") { ProductDetailViewController(scene: .apiError) }
