import SwiftUI

struct CekPromoBankIssuerView: View {
    @StateObject private var viewModel = CekPromoBankIssuerViewModel()
    
    var body: some View {
        ZStack {
            Color(hex: "#F5F5F5").ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                HStack {
                    Text("Promo Bank Issuer")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding()
                .background(Color.white)
                
                ScrollView {
                    VStack(spacing: 16) {
                        
                        VStack(alignment: .leading, spacing: 16) {
                            
                            
                            buildMenuPicker(
                                title: "Pilih Tier",
                                selectedLabel: viewModel.tiers.first(where: { $0.value == viewModel.selectedTier })?.label ?? "Pilih Tier",
                                options: viewModel.tiers.map { $0.label }
                            ) { selectedLabel in
                                if let tier = viewModel.tiers.first(where: { $0.label == selectedLabel }) {
                                    viewModel.selectedTier = tier.value
                                }
                            }
                            
                            
                            buildMenuPicker(
                                title: "Metode Pembayaran",
                                selectedLabel: viewModel.selectedPaymentMethod?.payment_method_name ?? "Pilih Metode Pembayaran",
                                options: viewModel.paymentMethods.compactMap { $0.payment_method_name }
                            ) { selectedLabel in
                                if let method = viewModel.paymentMethods.first(where: { $0.payment_method_name == selectedLabel }) {
                                    viewModel.handlePaymentMethodChange(method)
                                }
                            }
                            
                            
                            if !viewModel.bankOptions.isEmpty {
                                buildMenuPicker(
                                    title: "Bank",
                                    selectedLabel: viewModel.selectedBank?.bank_name ?? "Pilih Bank",
                                    options: viewModel.bankOptions.compactMap { $0.bank_name }
                                ) { selectedLabel in
                                    if let bank = viewModel.bankOptions.first(where: { $0.bank_name == selectedLabel }) {
                                        viewModel.onBankSelected(bank)
                                    }
                                }
                            }
                            
                            
                            if !viewModel.issuerOptions.isEmpty {
                                buildMenuPicker(
                                    title: "Issuer",
                                    selectedLabel: viewModel.selectedIssuer?.payment_issuer_name ?? "Pilih Issuer",
                                    options: viewModel.issuerOptions.compactMap { $0.payment_issuer_name }
                                ) { selectedLabel in
                                    if let issuer = viewModel.issuerOptions.first(where: { $0.payment_issuer_name == selectedLabel }) {
                                        viewModel.selectedIssuer = issuer
                                    }
                                }
                            }
                            
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Nominal Transaksi")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                
                                TextField("Masukkan nominal", text: $viewModel.nominal)
                                    .keyboardType(.numberPad)
                                    .padding()
                                    .background(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                            }
                            
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("SKU Produk")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                
                                TextField("Masukkan SKU", text: $viewModel.skuInput)
                                    .padding()
                                    .background(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                                    .autocapitalization(.allCharacters)
                                    .disableAutocorrection(true)
                            }
                            
                            
                            Button(action: {
                                hideKeyboard()
                                viewModel.searchPromo()
                            }) {
                                HStack {
                                    Spacer()
                                    if viewModel.isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    } else {
                                        Text("Cari")
                                            .font(.headline)
                                            .fontWeight(.bold)
                                    }
                                    Spacer()
                                }
                                .padding()
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                            }
                            .disabled(viewModel.isLoading)
                            
                            
                            if let error = viewModel.errorMessage {
                                Text(error)
                                    .font(.subheadline)
                                    .foregroundColor(.red)
                                    .padding(.top, 4)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                        
                        
                        if let product = viewModel.productInfo {
                            VStack(alignment: .leading, spacing: 16) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(product.article_description)
                                        .font(.headline)
                                        .fontWeight(.bold)
                                    Text(product.article_code)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                
                                Divider()
                                
                                HStack {
                                    Text("Stok Tersedia")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Text("\(viewModel.stock)")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                            
                            
                            if let cashback = viewModel.promoValidation {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Detail Promo/Cashback")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                    
                                    if let details = cashback.promotion_details, !details.isEmpty {
                                        ForEach(details) { detail in
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(detail.promotion_name ?? "Promo")
                                                    .font(.subheadline)
                                                    .fontWeight(.semibold)
                                                
                                                HStack {
                                                    Text("Tipe: \(detail.type ?? "-")")
                                                        .font(.caption)
                                                        .foregroundColor(.gray)
                                                    Spacer()
                                                    Text(detail.amount?.formatRupiah() ?? "Rp0")
                                                        .font(.subheadline)
                                                        .fontWeight(.bold)
                                                        .foregroundColor(.green)
                                                }
                                            }
                                            .padding()
                                            .background(Color.green.opacity(0.05))
                                            .cornerRadius(8)
                                        }
                                    } else {
                                        Text("Nggak dapet cashback/promo buat transaksi ini.")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                            .padding()
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(16)
                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    
    @ViewBuilder
    private func buildMenuPicker(title: String, selectedLabel: String, options: [String], onSelect: @escaping (String) -> Void) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
            
            Menu {
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        onSelect(option)
                    }) {
                        Text(option)
                    }
                }
            } label: {
                HStack {
                     Text(selectedLabel.isEmpty ? "Pilih \(title)" : selectedLabel)
                        .foregroundColor(selectedLabel.isEmpty ? .gray : .black)
                        .lineLimit(1)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            }
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
