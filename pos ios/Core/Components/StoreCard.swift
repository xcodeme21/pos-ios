import SwiftUI

struct StoreCard: View {
    let store: BusinessUnit
    let action: () -> Void
    @ObservedObject var theme = ThemeManager.shared

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 0) {

                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(theme.primaryColor.opacity(0.10))
                    Image(systemName: "storefront.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 32)
                        .foregroundColor(theme.primaryColor.opacity(0.75))
                }
                .frame(maxWidth: .infinity)
                .frame(height: 64)

                
                VStack(alignment: .leading, spacing: 5) {

                    
                    Text(store.siteCode)
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 3)
                        .background(theme.primaryColor.opacity(0.12))
                        .foregroundColor(theme.primaryColor)
                        .cornerRadius(6)
                        .lineLimit(1)

                    
                    Text(store.siteName)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(.label))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)

                    
                    Text(store.companyCode)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                .frame(minHeight: 90, alignment: .top)
            }
            .background(Color(.systemBackground))
            .cornerRadius(14)
            .shadow(color: Color.black.opacity(0.07), radius: 8, x: 0, y: 3)
            
            .frame(maxHeight: .infinity)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
