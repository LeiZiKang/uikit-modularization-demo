import UIKit
import SwiftUI
import Components
import DataModel

protocol ItemAPI {
    func load() async throws -> [ItemDTO]
}

enum PreviewScene: String {
    case success, empty, loading
    case unauthorized = "401"
    case serverError = "500"
}

enum ItemAPIError: Error {
    case http(Int)
}

struct FixtureItemAPI: ItemAPI {
    let scene: PreviewScene

    func load() async throws -> [ItemDTO] {
        switch scene {
        case .success:
            return [ItemDTO(title: "Item", amountInCents: 1299, status: "active")]
        case .empty:
            return []
        case .loading:
            // Keep loading until the preview task is cancelled.
            while !Task.isCancelled {
                try await Task.sleep(for: .seconds(60))
            }
            throw CancellationError()
        case .unauthorized:
            throw ItemAPIError.http(401)
        case .serverError:
            throw ItemAPIError.http(500)
        }
    }
}

@MainActor
final class ItemViewController: UIViewController {
    private let api: any ItemAPI
    private let badge = BadgeLabel(configuration: .init(
        text: "Loading…", color: .secondaryLabel
    ))
    private var loadTask: Task<Void, Never>?

    init(api: any ItemAPI) {
        self.api = api
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("Use init(api:)") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        badge.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(badge)
        NSLayoutConstraint.activate([
            badge.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            badge.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            badge.leadingAnchor.constraint(
                greaterThanOrEqualTo: view.leadingAnchor, constant: 24
            ),
            badge.trailingAnchor.constraint(
                lessThanOrEqualTo: view.trailingAnchor, constant: -24
            )
        ])
        let api = self.api
        loadTask = Task { [weak self] in
            do {
                let items = try await api.load()
                try Task.checkCancellation()
                let text = items.map {
                    let model = ItemViewModel(dto: $0, locale: Locale(identifier: "en_US"))
                    return "\(model.title) · \(model.amountText) · \(model.statusText)"
                }.joined(separator: "\n")
                self?.render(items.isEmpty ? "No items" : text, color: .label)
            } catch is CancellationError {
                return
            } catch ItemAPIError.http(401) {
                self?.render("Please sign in", color: .systemOrange)
            } catch ItemAPIError.http(500) {
                self?.render("Server error", color: .systemRed)
            } catch {
                self?.render("Unable to load", color: .systemRed)
            }
        }
    }

    func cancelLoading() { loadTask?.cancel() }

    private func render(_ text: String, color: UIColor) {
        badge.apply(.init(text: text, color: color))
    }
}

#if DEBUG
@available(iOS 17.0, *)
private struct ItemCanvas: UIViewControllerRepresentable {
    let scene: PreviewScene

    func makeUIViewController(context: Context) -> ItemViewController {
        ItemViewController(api: FixtureItemAPI(scene: scene))
    }

    func updateUIViewController(_ controller: ItemViewController, context: Context) {}

    static func dismantleUIViewController(
        _ controller: ItemViewController, coordinator: Void
    ) {
        controller.cancelLoading()
    }
}

#Preview("Success", traits: .fixedLayout(width: 390, height: 500)) {
    ItemCanvas(scene: .success)
}
#Preview("Empty") { ItemCanvas(scene: .empty) }
#Preview("Loading") { ItemCanvas(scene: .loading) }
#Preview("401") { ItemCanvas(scene: .unauthorized) }
#Preview("500") { ItemCanvas(scene: .serverError) }
#endif
