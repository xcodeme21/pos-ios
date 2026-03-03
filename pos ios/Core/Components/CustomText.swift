import SwiftUI

struct CustomText: View {
    let text: String
    var font: Font = .body
    var weight: Font.Weight = .regular
    var color: Color = .primary
    var lineLimit: Int? = nil
    
    var body: some View {
        Text(text)
            .font(font)
            .fontWeight(weight)
            .foregroundColor(color)
            .lineLimit(lineLimit)
    }
}
