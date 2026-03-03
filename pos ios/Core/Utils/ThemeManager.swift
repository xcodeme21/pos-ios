import SwiftUI
import Combine

class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    @Published var primaryColorHex: String = "#fda5cb" 
    @Published var primaryLightColorHex: String = "#EFEFEF"
    @Published var secondaryColorHex: String = "#FFFFFF"
    
    var primaryColor: Color {
        Color(hex: primaryColorHex)
    }
    
    var primaryLightColor: Color {
        Color(hex: primaryLightColorHex)
    }
    
    var secondaryColor: Color {
        Color(hex: secondaryColorHex)
    }
    
    private init() {}
    
    func parseSettings(_ settings: [StoreSetting]) {
        for setting in settings {
            if setting.name == "primary" && setting.type == "text" {
                self.primaryColorHex = setting.value
            } else if setting.name == "primaryLight" && setting.type == "text" {
                self.primaryLightColorHex = setting.value
            } else if setting.name == "secondary" && setting.type == "text" {
                self.secondaryColorHex = setting.value
            }
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: 
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: 
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: 
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
