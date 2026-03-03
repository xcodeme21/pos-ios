import SwiftUI

struct CekPromoView: View {
    @ObservedObject var theme = ThemeManager.shared
    @State private var selectedPromoType: PromoType? = nil
    
    enum PromoType {
        case item
        case bankIssuer
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#F5F5F5").ignoresSafeArea() 
                
                VStack(spacing: 20) {
                    HStack {
                        Text("Cek Promo")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .padding()
                    .background(Color.white)
                    
                    VStack(spacing: 16) {
                        NavigationLink(value: PromoType.item) {
                            PromoOptionCard(
                                title: "Cek Promo Item",
                                description: "Lihat promo untuk SKU produk tertentu",
                                iconName: "tag.fill",
                                color: .blue
                            )
                        }
                        
                        NavigationLink(value: PromoType.bankIssuer) {
                            PromoOptionCard(
                                title: "Cek Promo Bank Issuer",
                                description: "Lihat promo dan cashback dari bank/issuer",
                                iconName: "creditcard.fill",
                                color: .orange
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(for: PromoType.self) { promoType in
                switch promoType {
                case .item:
                    CekPromoItemView()
                case .bankIssuer:
                    CekPromoBankIssuerView()
                }
            }
        }
    }
}

struct PromoOptionCard: View {
    let title: String
    let description: String
    let iconName: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 50, height: 50)
                Image(systemName: iconName)
                    .font(.title2)
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.black)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct CekPromoView_Previews: PreviewProvider {
    static var previews: some View {
        CekPromoView()
    }
}
