import SwiftUI

struct AkunSayaView: View {
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
                    Text("Informasi Akun")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .padding(.leading, 8)
                    
                    VStack(spacing: 0) {
                        AkunInfoRow(icon: "person.fill", label: "Nama Lengkap", value: displayName)
                        Divider().padding(.leading, 44)
                        AkunInfoRow(icon: "envelope.fill", label: "Email", value: savedUsername)
                        Divider().padding(.leading, 44)
                        AkunInfoRow(icon: "number", label: "User ID", value: savedUserId.isEmpty ? "-" : savedUserId)
                    }
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                }

    
                VStack(alignment: .leading, spacing: 8) {
                    Text("Keamanan")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .padding(.leading, 8)
                    
                    Button {
                        if let url = URL(string: "https://webmail.erajaya.com/public/PasswordRecovery.jsp?") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        HStack {
                            Image(systemName: "lock.rotation")
                                .foregroundColor(.secondary)
                                .frame(width: 24)
                            Text("Ganti Kata Sandi")
                                .foregroundColor(Color(.label))
                                .font(.subheadline)
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(.systemGray3))
                        }
                        .padding(16)
                        .background(Color(.systemBackground))
                        .cornerRadius(16)
                    }
                }

    
                VStack(alignment: .leading, spacing: 8) {
                    VStack(spacing: 0) {
                        AkunInfoRow(icon: "info.circle", label: "Versi Aplikasi", value: appVersion())
                    }
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                }
            }
            .padding(20)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle("Akun Saya")
        .navigationBarTitleDisplayMode(.large)
    }

    private func appVersion() -> String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }
}

struct AkunInfoRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.secondary)
                .frame(width: 24)
            Text(label)
                .font(.subheadline)
                .foregroundColor(Color(.label))
            Spacer()

            Text(value)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
        .padding(16)
    }
}
