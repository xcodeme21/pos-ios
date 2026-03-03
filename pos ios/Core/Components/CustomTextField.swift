import SwiftUI

struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    var label: String? = nil
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    var systemImage: String? = nil
    var style: TextFieldStyle = .plain
    
    @State private var isPasswordVisible: Bool = false
    
    enum TextFieldStyle {
        case plain      
        case glass      
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            
            if let label = label {
                Text(label)
                    .font(.subheadline)
                    .foregroundColor(Color(.label).opacity(0.6))
            }
            
            fieldContent
        }
    }
    
    @ViewBuilder
    private var fieldContent: some View {
        HStack(spacing: 10) {
            if let systemImage = systemImage {
                Image(systemName: systemImage)
                    .foregroundColor(.gray)
                    .frame(width: 18)
            }
            
            if isSecure && !isPasswordVisible {
                SecureField(placeholder, text: $text)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            } else {
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            
            
            if isSecure {
                Button {
                    isPasswordVisible.toggle()
                } label: {
                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .background(fieldBackground)
    }
    
    @ViewBuilder
    private var fieldBackground: some View {
        switch style {
        case .plain:
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
        case .glass:
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        }
    }
}
