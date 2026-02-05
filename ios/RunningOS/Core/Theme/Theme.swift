import SwiftUI

// MARK: - App Colors

enum AppColors {
    // Primary colors from design
    static let primary = Color(hex: "7F0DF2")
    static let primaryGlow = Color(hex: "9D4BF6")
    static let background = Color(hex: "0A0E14")
    static let surface = Color(hex: "131620")
    static let surfaceTransparent = Color(hex: "131620", alpha: 0.4)
    static let gridLine = Color(hex: "7F0DF2", alpha: 0.05)

    // Text colors
    static let textPrimary = Color.white
    static let textSecondary = Color(hex: "9CA3AF")
    static let textTertiary = Color(hex: "6B7280")

    // Heatmap colors - exact from CSS
    static let heatmapEmpty = Color(hex: "1E2330")
    static let heatmapLevel1 = Color(hex: "7F0DF2").opacity(0.2)
    static let heatmapLevel2 = Color(hex: "7F0DF2").opacity(0.5)
    static let heatmapLevel3 = Color(hex: "7F0DF2").opacity(0.8)
    static let heatmapLevel4 = Color(hex: "7F0DF2")

    // Icon colors
    static let iconDefault = Color(hex: "9CA3AF")
}

// MARK: - App Fonts

enum AppFonts {
    // Space Grotesk font family as specified in design
    // Font names match the exact filenames provided to iOS
    static func display(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        let fontName: String
        switch weight {
        case .bold, .heavy:
            fontName = "SpaceGrotesk-Bold"
        case .medium, .semibold:
            fontName = "SpaceGrotesk-Medium"
        default:
            fontName = "SpaceGrotesk-Regular"
        }

        if let font = UIFont(name: fontName, size: size) {
            return Font(font)
        }
        // Fallback to system font if Space Grotesk is not available
        return Font.system(size: size, weight: weight)
    }

    static func label(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        let fontName: String
        switch weight {
        case .bold, .heavy:
            fontName = "SpaceGrotesk-Bold"
        case .medium, .semibold:
            fontName = "SpaceGrotesk-Medium"
        default:
            fontName = "SpaceGrotesk-Regular"
        }

        if let font = UIFont(name: fontName, size: size) {
            return Font(font)
        }
        // Fallback to system font if Space Grotesk is not available
        return Font.system(size: size, weight: weight)
    }
}

// MARK: - Color Extensions

extension Color {
    init(hex: String, alpha: Double = 1) {
        let scanner = Scanner(string: hex)
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        self.init(.sRGB, red: r, green: g, blue: b, opacity: alpha)
    }
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1) {
        let scanner = Scanner(string: hex)
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let g = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let b = CGFloat(rgb & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}
