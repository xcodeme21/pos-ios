import SwiftUI

struct DashboardView: View {
    let store: BusinessUnit
    @ObservedObject var theme = ThemeManager.shared
    @State private var selectedTab = 0
    @AppStorage("authToken") private var authToken: String = ""
    @AppStorage("savedUsername") private var savedUsername: String = ""
    @State private var isLoggedOut = false

    var body: some View {
        ZStack {
            if isLoggedOut {
                LoginView()
            } else {
                TabView(selection: $selectedTab) {

                    TransactionView(store: store)
                        .tabItem {
                            Label("Transaksi", systemImage: "cart.fill")
                        }
                        .tag(0)

                    PlaceholderMenuView(title: "RJ", icon: "arrow.triangle.2.circlepath")
                        .tabItem {
                            Label("RJ", systemImage: "arrow.triangle.2.circlepath")
                        }
                        .tag(1)

                    PlaceholderMenuView(title: "Era Express", icon: "shippingbox.fill")
                        .tabItem {
                            Label("Era Express", systemImage: "shippingbox.fill")
                        }
                        .tag(2)

                    PlaceholderMenuView(title: "CNP", icon: "creditcard.fill")
                        .tabItem {
                            Label("CNP", systemImage: "creditcard.fill")
                        }
                        .tag(3)

                    CekPromoView()
                        .tabItem {
                            Label("Cek Promo", systemImage: "tag.fill")
                        }
                        .tag(4)

                    LaporanView(store: store)
                        .tabItem {
                            Label("Laporan", systemImage: "chart.bar.fill")
                        }
                        .tag(5)

                    ProfilView(store: store, onLogout: {
                        authToken = ""
                        savedUsername = ""
                        UserDefaults.standard.removeObject(forKey: "savedStore")
                        UserDefaults.standard.removeObject(forKey: "buCode")
                        isLoggedOut = true
                    })
                    .tabItem {
                        Label("Profil", systemImage: "person.fill")
                    }
                    .tag(6)
                }
                .accentColor(theme.primaryColor)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
