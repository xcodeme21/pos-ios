import SwiftUI

struct GlassBackground: ViewModifier {
    var cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .cornerRadius(cornerRadius)
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
    }
}

extension View {
    func glassmorphism(cornerRadius: CGFloat = 16) -> some View {
        self.modifier(GlassBackground(cornerRadius: cornerRadius))
    }
}
