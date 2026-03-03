import SwiftUI

struct OrderHeaderView: View {
    @Binding var selectedSalesman: SalesPerson?
    @Binding var selectedCustomer: Customer?
    let onSelectSalesman: () -> Void
    let onSelectCustomer: () -> Void
    
    @ObservedObject var theme = ThemeManager.shared
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 16) {
                Button(action: onSelectSalesman) {
                    HStack {
                        Image(systemName: "person.text.rectangle")
                            .foregroundColor(selectedSalesman != nil ? theme.primaryColor : .secondary)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Sales")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            Text(selectedSalesman?.fullName ?? "Pilih Sales")
                                .font(.caption)
                                .fontWeight(selectedSalesman != nil ? .semibold : .regular)
                                .foregroundColor(selectedSalesman != nil ? .primary : .secondary)
                                .lineLimit(1)
                        }
                        Spacer()
                        Image(systemName: "chevron.down")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
                
                Button(action: onSelectCustomer) {
                    HStack {
                        Image(systemName: "person.crop.circle")
                            .foregroundColor(selectedCustomer != nil ? theme.primaryColor : .secondary)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Customer")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            Text(selectedCustomer?.name ?? "Pilih Customer")
                                .font(.caption)
                                .fontWeight(selectedCustomer != nil ? .semibold : .regular)
                                .foregroundColor(selectedCustomer != nil ? .primary : .secondary)
                                .lineLimit(1)
                        }
                        Spacer()
                        Image(systemName: "chevron.down")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
            }
            .padding(16)
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 3)
        .padding(.horizontal, 16)
    }
}
