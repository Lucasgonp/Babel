import UIKit

public enum Font {
    /// XX Large.
    public static var xxl: FontSystemStyle = .init(size: 32)
    
    /// X Large.
    public static var xl: FontSystemStyle = .init(size: 28)
    
    /// Large.
    public static var lg: FontSystemStyle = .init(size: 20)
    
    /// Medium.
    public static var md: FontSystemStyle = .init(size: 16)
    
    /// Small.
    public static var sm: FontSystemStyle = .init(size: 14)
    
    /// X Small.
    public static var xs: FontSystemStyle = .init(size: 12)
    
    /// XX Small.
    public static var xxs: FontSystemStyle = .init(size: 8)
    
    public enum Verdana: String {
        case bold = "Bold"
        case heavy = "Heavy"
        case medium = "Medium"
        case regular = "Regular"
        case demiBold = "DemiBold"
        
        static private var named = "AvenirNext-"
        
        public func font(size: Size) -> UIFont {
            let fontName = "\(Verdana.named)\(rawValue)"
            return UIFont(name: fontName, size: size.rawValue)!
        }
    }
    
    public enum Size: CGFloat {
        case xxl
        case xl
        case lg
        case md
        case sm
        case xs
        case xxs
        
        public var rawValue: CGFloat {
            switch self {
            case .xxl:
                32
            case .xl:
                28
            case .lg:
                20
            case .md:
                16
            case .sm:
                14
            case .xs:
                12
            case .xxs:
                8
            }
        }
    }
}
