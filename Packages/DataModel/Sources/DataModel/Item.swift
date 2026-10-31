import Foundation

public struct ItemDTO: Codable {
    public let title: String?
    public let amountInCents: Int?
    public let status: String?

    public init(title: String?, amountInCents: Int?, status: String?) {
        self.title = title
        self.amountInCents = amountInCents
        self.status = status
    }
}

public struct ItemViewModel {
    public let title: String
    public let amountText: String
    public let statusText: String

    public init(dto: ItemDTO, locale: Locale) {
        let title = dto.title?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.title = title.flatMap { $0.isEmpty ? nil : $0 } ?? "Untitled"
        if let cents = dto.amountInCents {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.locale = locale
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2
            let amount = NSDecimalNumber(value: cents).dividing(by: 100)
            amountText = formatter.string(from: amount) ?? "—"
        } else {
            amountText = "—"
        }
        statusText = dto.status == "active" ? "Available" : "Unavailable"
    }
}
