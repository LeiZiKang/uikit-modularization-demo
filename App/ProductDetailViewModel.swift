import Foundation
import ProductUI
enum StockStatus { case inStock, soldOut, outOfStock, restocking(expected: String) }
struct Product { let stock: StockStatus }
protocol ProductLoading {
    func load() throws -> Product
    func buy() throws
}
final class ProductDetailViewModel {
    struct State {
        let info: ProductInfoCardView.Content
        let purchase: PurchaseBarView.Content
        var errorMessage: String?
    }
    private(set) var state: State?
    var onStateChange: ((State) -> Void)?
    private let loader: ProductLoading
    private var product: Product?
    init(loader: ProductLoading) { self.loader = loader }
    func load() {
        do {
            let product = try loader.load()
            self.product = product
            state = content(for: product.stock)
        } catch {
            product = nil
            state = content(for: .soldOut)
            state?.errorMessage = error.localizedDescription
        }
        if let state { onStateChange?(state) }
    }
    func buyTapped() {
        guard let product else { return }
        if case .soldOut = product.stock { return }
        do { try loader.buy(); state?.errorMessage = nil }
        catch { state?.errorMessage = error.localizedDescription }
        if let state { onStateChange?(state) }
    }
    private func content(for stock: StockStatus) -> State {
        let tag: String, button: String, style: StockTagView.Style, enabled: Bool, note: String?
        switch stock {
        case .inStock:
            (tag, button, style, enabled, note) = ("In Stock", "Add to Cart", .available, true, nil)
        case .soldOut:
            (tag, button, style, enabled, note) = ("Sold Out", "Sold Out", .unavailable, false,
                                                 "This item won't be restocked.")
        case .outOfStock:
            (tag, button, style, enabled, note) = ("Out of Stock", "Notify Me", .unavailable, true, nil)
        case .restocking(let expected):
            (tag, button, style, enabled, note) = ("Restocking", "Notify Me", .pending, true,
                                                 "Expected back \(expected)")
        }
        return State(info: .init(title: "Canvas Tote", subtitle: "Natural / Everyday collection",
                                 price: .init(priceText: "$28.00", originalPriceText: "$36.00"),
                                 stockTag: .init(text: tag, style: style)),
                     purchase: .init(button: .init(title: button, isEnabled: enabled), note: note))
    }
}
