import SwiftUI

struct CustomButton: View {
    let title: String
    let action: () -> Void
    var style: ButtonStyle = .primary
    var isDisabled: Bool = false
    var isLoading: Bool = false
    
    enum ButtonStyle {
        case primary    
        case glass     
        case outline    
    }
    
    
    var customBackground: Color? = nil
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Label {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                } icon: {
                    EmptyView()
                }
                .opacity(isLoading ? 0 : 1)
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: tintColor))
                }
            }
            .foregroundColor(isDisabled ? .gray : tintColor)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(backgroundView)
        }
        .disabled(isDisabled || isLoading)
    }
    
    private var tintColor: Color {
        switch style {
        case .primary: return .white
        case .glass:   return isDisabled ? .gray : .white
        case .outline: return isDisabled ? .gray : Color(.label)
        }
    }
    
    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .primary:
            Capsule()
                .fill(isDisabled ? Color.gray.opacity(0.3) : (customBackground ?? Color.black))
        case .glass:
            Capsule()
                .fill(isDisabled ? Color.gray.opacity(0.2) : Color.blue.opacity(0.6))
                .overlay(Color.white.opacity(0.1))
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        case .outline:
            Capsule()
                .stroke(isDisabled ? Color.gray.opacity(0.4) : Color(.systemGray3), lineWidth: 1.5)
        }
    }
}
