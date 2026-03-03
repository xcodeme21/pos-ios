import SwiftUI

struct ProfilView: View {
    let store: BusinessUnit
    let onLogout: () -> Void
    @AppStorage("savedUsername") private var savedUsername: String = ""
    @AppStorage("savedUserId") private var savedUserId: String = ""
    @ObservedObject var theme = ThemeManager.shared

    private var displayName: String { savedUsername.toDisplayName }
    private var initials: String { displayName.toInitials }

    var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    

                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(theme.primaryColor.opacity(0.8))
                                .frame(width: 64, height: 64)
                            Text(initials)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(displayName)
                                .font(.headline)
                                .fontWeight(.bold)
                            Text(savedUsername)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 6, height: 6)
                                Text("Aktif")
                                    .font(.caption2)
                                    .fontWeight(.medium)
                                    .foregroundColor(.green)
                            }
                            .padding(.top, 2)
                        }
                        Spacer()
                    }
                    .padding(16)
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Akun")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                            .padding(.leading, 8)
                        
                        NavigationLink(destination: AkunSayaView()) {
                            HStack {
                                Image(systemName: "person.circle")
                                    .foregroundColor(.secondary)
                                    .frame(width: 24)
                                Text("Akun Saya")
                                    .foregroundColor(Color(.label))
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color(.systemGray3))
                            }
                            .padding(16)
                            .background(Color(.systemBackground))
                            .cornerRadius(16)
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Toko Aktif")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                            .padding(.leading, 8)
                        
                        HStack(alignment: .center, spacing: 12) {
                            Image(systemName: "storefront")
                                .foregroundColor(.secondary)
                                .frame(width: 24)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(store.storeName)
                                    .font(.subheadline)
                                    .foregroundColor(Color(.label))
                                    .multilineTextAlignment(.leading)
                                Text("Kode: \(store.siteCode)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                        .padding(16)
                        .background(Color(.systemBackground))
                        .cornerRadius(16)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Button(action: {
                            savedUserId = ""
                            onLogout()
                        }) {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .foregroundColor(.red)
                                    .frame(width: 24)
                                Text("Keluar")
                                    .fontWeight(.medium)
                                    .foregroundColor(.red)
                                Spacer()
                            }
                            .padding(16)
                            .background(Color(.systemBackground))
                            .cornerRadius(16)
                        }
                        
                        Text("Kamu harus login ulang untuk ganti toko ya.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.leading, 8)
                    }
                }
                .padding(20)
            }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle("Profil")
        .navigationBarTitleDisplayMode(.large)
    }
}
