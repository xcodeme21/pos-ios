import Foundation

extension String {

    var toDisplayName: String {
        let namePart = self.components(separatedBy: "@").first ?? self
        let parts = namePart.components(separatedBy: ".")
        return parts.map { $0.capitalized }.joined(separator: " ")
    }
    
    var toInitials: String {
        let parts = self.components(separatedBy: " ").filter { !$0.isEmpty }
        if parts.count >= 2 {
            return String(parts[0].prefix(1) + parts[1].prefix(1)).uppercased()
        } else if let first = parts.first {
            return String(first.prefix(2)).uppercased()
        }
        return "?"
    }
}

extension Int {
    func formatRupiah() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "id_ID")
        formatter.currencySymbol = "Rp"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: self)) ?? "Rp\(self)"
    }
}
