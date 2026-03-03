import SwiftUI

struct CheckoutModalSheet: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: TransactionViewModel
    @ObservedObject var theme = ThemeManager.shared
    
    @State private var selectedPaymentMethod: PaymentMethod = .cash
    
    enum PaymentMethod: String, CaseIterable {
        case cash = "Tunai"
        case qris = "QRIS"
        case edc = "EDC Kartu"
        case transfer = "Transfer"
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Daftar Belanja")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            if viewModel.cartItems.isEmpty {
                                Text("Keranjang kosong")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.vertical, 20)
                            } else {
                                ForEach(viewModel.cartItems) { item in
                                    cartItemRow(item: item)
                                    Divider()
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Metode Pembayaran")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 16)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(PaymentMethod.allCases, id: \.self) { method in
                                        Button(action: { selectedPaymentMethod = method }) {
                                            Text(method.rawValue)
                                                .font(.subheadline)
                                                .fontWeight(selectedPaymentMethod == method ? .semibold : .regular)
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 10)
                                                .background(selectedPaymentMethod == method ? theme.primaryColor : Color(.systemGray6))
                                                .foregroundColor(selectedPaymentMethod == method ? .white : .primary)
                                                .cornerRadius(20)
                                        }
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                        }
                        
                        VStack(spacing: 12) {
                            summaryRow(title: "Subtotal", amount: viewModel.totalAmount, isBold: false)
                            summaryRow(title: "Diskon", amount: 0, isBold: false)
                            Divider()
                            summaryRow(title: "Total Tagihan", amount: viewModel.totalAmount, isBold: true)
                        }
                        .padding(16)
                        .background(Color(.systemGray6).opacity(0.5))
                        .cornerRadius(12)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 20)
                    }
                }
                
                VStack {
                    Button(action: processPayment) {
                        Text("Bayar Sekarang - \(formatCurrency(viewModel.totalAmount))")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(16)
                            .background(theme.primaryColor)
                            .foregroundColor(.white)
                            .cornerRadius(14)
                    }
                    .disabled(viewModel.cartItems.isEmpty)
                    .opacity(viewModel.cartItems.isEmpty ? 0.5 : 1)
                }
                .padding(16)
                .background(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 10, y: -5)
            }
            .navigationTitle("Checkout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { isPresented = false }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                            .font(.headline)
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        viewModel.clearCart()
                        isPresented = false
                    }) {
                        Text("Kosongkan")
                            .font(.subheadline)
                            .foregroundColor(.red)
                    }
                }
            }
        }
    }
    
    
    private func cartItemRow(item: CartItem) -> some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Rectangle()
                    .fill(Color(.systemGray6))
                    .frame(width: 50, height: 50)
                    .cornerRadius(8)
                Image(systemName: "cube.box.fill")
                    .foregroundColor(theme.primaryColor.opacity(0.4))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.product.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text("\(formatCurrency(item.product.price))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                Button(action: { viewModel.updateQuantity(for: item, newQuantity: item.quantity - 1) }) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.secondary)
                        .font(.title3)
                }
                
                Text("\(item.quantity)")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .frame(minWidth: 20)
                
                Button(action: { viewModel.updateQuantity(for: item, newQuantity: item.quantity + 1) }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(theme.primaryColor)
                        .font(.title3)
                }
            }
        }
    }
    
    private func summaryRow(title: String, amount: Double, isBold: Bool) -> some View {
        HStack {
            Text(title)
                .font(isBold ? .subheadline : .caption)
                .fontWeight(isBold ? .bold : .regular)
                .foregroundColor(isBold ? .primary : .secondary)
            Spacer()
            Text(formatCurrency(amount))
                .font(isBold ? .subheadline : .caption)
                .fontWeight(isBold ? .bold : .medium)
                .foregroundColor(isBold ? theme.primaryColor : .primary)
        }
    }
    
    
    private func processPayment() {
        print("Processing payment of \(formatCurrency(viewModel.totalAmount)) via \(selectedPaymentMethod.rawValue)")
        
        viewModel.clearCart()
        isPresented = false
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
