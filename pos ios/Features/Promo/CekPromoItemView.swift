import SwiftUI

struct CekPromoItemView: View {
    @StateObject private var viewModel = CekPromoItemViewModel()
    
    @State private var selectedTier = "00"
    @State private var skuInput = ""
    @State private var promoSearchQuery = ""
    
    var filteredPromoList: [PromoDetail] {
        if promoSearchQuery.isEmpty {
            return viewModel.promoList
        }
        return viewModel.promoList.filter {
            $0.promotion_description?.localizedCaseInsensitiveContains(promoSearchQuery) == true ||
            $0.promotion_id?.localizedCaseInsensitiveContains(promoSearchQuery) == true
        }
    }
    
    var body: some View {
        ZStack {
            Color(hex: "#F5F5F5").ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                HStack {
                    Text("Promo Item")
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
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Pilih Tier")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                
                                Menu {
                                    ForEach(viewModel.tiers, id: \.value) { tier in
                                        Button(action: {
                                            selectedTier = tier.value
                                        }) {
                                            Text(tier.label)
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Text(viewModel.tiers.first(where: { $0.value == selectedTier })?.label ?? "Pilih Tier")
                                            .foregroundColor(.black)
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
                            
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("SKU Produk")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                
                                TextField("Masukin SKU barangnya...", text: $skuInput)
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
                                viewModel.searchPromo(tierCode: selectedTier, sku: skuInput)
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
                                    
                                    if viewModel.regularPrice > 0 {
                                        Text(viewModel.regularPrice.formatRupiah())
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .foregroundColor(.black)
                                            .padding(.top, 4)
                                    }
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
                            
                            
                            HStack {
                                TextField("Cari promo...", text: $promoSearchQuery)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
                            }
                            
                            
                            if filteredPromoList.isEmpty && !viewModel.isLoading {
                                Text("Nggak ada promo yang pas nih.")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .padding()
                            } else {
                                ForEach(filteredPromoList) { promo in
                                    PromoDetailCard(promo: promo)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct PromoDetailCard: View {
    let promo: PromoDetail
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(promo.promotion_id ?? "-")
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.1))
                    .foregroundColor(.green)
                    .cornerRadius(8)
                Spacer()
            }
            
            Text(promo.promotion_description ?? "-")
                .font(.headline)
                .foregroundColor(.black)
                .fixedSize(horizontal: false, vertical: true)
            
            
            if let list = promo.promo_list, !list.isEmpty {
                Divider()
                ForEach(list) { item in
                    VStack(alignment: .leading, spacing: 8) {
                        if let desc = item.bonus_buy_description, !desc.isEmpty {
                            Text(desc)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.blue)
                        }
                        
                        
                        if let reqs = item.requirement_item, !reqs.isEmpty {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Syarat Barang:")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                ForEach(reqs.indices, id: \.self) { i in
                                    if let groupReqs = reqs[i].requirement_item {
                                        ForEach(groupReqs.indices, id: \.self) { j in
                                            Text("• \(groupReqs[j].article_description ?? "-") (\(groupReqs[j].article_code ?? "-"))")
                                                .font(.caption)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
