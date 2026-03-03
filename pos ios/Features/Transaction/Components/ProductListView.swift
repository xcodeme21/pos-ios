import SwiftUI

struct ProductListView: View {
    @ObservedObject var viewModel: TransactionViewModel
    @ObservedObject var theme = ThemeManager.shared
    
    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField("Cari produk...", text: $viewModel.searchQuery)
                    .textFieldStyle(PlainTextFieldStyle())
                if !viewModel.searchQuery.isEmpty {
                    Button(action: { viewModel.searchQuery = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            
            ScrollView {
                if viewModel.filteredProducts.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "bag.badge.minus")
                            .font(.system(size: 40))
                            .foregroundColor(.secondary)
                        Text("Produk tidak ditemukan")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 40)
                } else {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.filteredProducts) { product in
                            ProductCell(product: product, theme: theme) {
                                viewModel.addToCart(product: product)
                            }
                        }
                    }
                    .padding(16)
                    .padding(.bottom, 80)
                }
            }
        }
    }
}

struct ProductCell: View {
    let product: Product
    let theme: ThemeManager
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack {
                Rectangle()
                    .fill(Color(.systemGray5))
                    .aspectRatio(1, contentMode: .fit)
                    .cornerRadius(10)
                Image(systemName: "cube.box.fill")
                    .font(.system(size: 30))
                    .foregroundColor(theme.primaryColor.opacity(0.3))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(formatCurrency(product.price))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(theme.primaryColor)
                
                Text("Stok: \(product.stock)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Button(action: action) {
                HStack(spacing: 4) {
                    Image(systemName: "plus")
                        .font(.caption2)
                    Text("Tambah")
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .font(.caption)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(theme.primaryColor)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .padding(10)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 3)
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
