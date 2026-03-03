import SwiftUI

struct CartSummaryView: View {
    let totalItems: Int
    let totalAmount: Double
    let theme: ThemeManager
    let action: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Image(systemName: "cart.fill")
                            .font(.subheadline)
                        Text("\(totalItems) Item")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.white.opacity(0.9))
                    
                    Text(formatCurrency(totalAmount))
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Button(action: action) {
                    HStack(spacing: 6) {
                        Text("Bayar")
                            .fontWeight(.semibold)
                        Image(systemName: "chevron.right")
                            .font(.caption)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color.white)
                    .foregroundColor(theme.primaryColor)
                    .cornerRadius(24)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(theme.primaryColor)
            .cornerRadius(20)
            .shadow(color: theme.primaryColor.opacity(0.3), radius: 10, y: 5)
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
    }
    
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "id_ID")
        formatter.currencySymbol = "Rp "
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "Rp 0"
    }
}
