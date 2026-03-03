import SwiftUI

struct TransactionView: View {
    let store: BusinessUnit
    @ObservedObject var theme = ThemeManager.shared

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {

                    HStack(spacing: 14) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(theme.primaryColor.opacity(0.12))
                                .frame(width: 52, height: 52)
                            Image(systemName: "storefront.fill")
                                .font(.system(size: 24))
                                .foregroundColor(theme.primaryColor)
                        }
                        VStack(alignment: .leading, spacing: 3) {
                            Text(store.storeName)
                                .font(.headline)
                                .fontWeight(.semibold)
                            Text("Kode: \(store.siteCode)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Image(systemName: "circle.fill")
                            .font(.caption2)
                            .foregroundColor(.green)
                    }
                    .padding(16)
                    .background(Color(.systemBackground))
                    .cornerRadius(14)
                    .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 3)


                    VStack(spacing: 16) {
                        Image(systemName: "cart.fill")
                            .font(.system(size: 52))
                            .foregroundColor(theme.primaryColor.opacity(0.4))
                        Text("Belum ada transaksi")
                            .font(.title3)
                            .fontWeight(.semibold)
                        Text("Mulai transaksi baru dengan menekan\ntombol di bawah ini.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 40)


                    Button(action: {
                        print("Transaksi baru tapped")
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Transaksi Baru")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(16)
                        .background(theme.primaryColor)
                        .foregroundColor(.white)
                        .cornerRadius(14)
                    }
                }
                .padding(16)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Transaksi")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
