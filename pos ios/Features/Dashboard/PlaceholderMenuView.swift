import SwiftUI

struct PlaceholderMenuView: View {
    let title: String
    let icon: String
    @ObservedObject var theme = ThemeManager.shared

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                Image(systemName: icon)
                    .font(.system(size: 56))
                    .foregroundColor(theme.primaryColor.opacity(0.5))
                Text("Menu \(title)")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text("Fitur ini sedang dalam pengembangan.\nNantikan update selanjutnya ya!")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            .padding(.horizontal, 40)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
