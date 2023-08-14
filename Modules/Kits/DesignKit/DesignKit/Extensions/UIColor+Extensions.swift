import UIKit

public extension UIColor {
    /// The hexadecimal value of the color.
    var hex: String {
        let ciColor = CIColor(color: self)
        return String(format: "#%02lX%02lX%02lX%02lX", lroundf(Float(ciColor.red * 255)), lroundf(Float(ciColor.green * 255)), lroundf(Float(ciColor.blue * 255)), lroundf(Float(ciColor.alpha * 255)))
    }

    /// Creates a color object using the Hexadecimal values specified by a string.
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)

        let r, g, b, a: UInt64
        switch hex.count {
        case 3:
            (r, g, b, a) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17, 255)
        case 6:
            (r, g, b, a) = (int >> 16, int >> 8 & 0xFF, int & 0xFF, 255)
        case 8:
            (r, g, b, a) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b, a) = (0, 0, 0, 255)
        }

        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }

    func withAlphaComponent(opacity: CGFloat) -> UIColor {
        withAlphaComponent(opacity)
    }
}
