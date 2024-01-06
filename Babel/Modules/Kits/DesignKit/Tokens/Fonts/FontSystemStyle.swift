import UIKit

public struct FontSystemStyle: FontStyle {
    public let size: CGFloat
    public var isBold: Bool
    public var isItalic: Bool
    public var uiFont: UIFont {
        return make(isBold: isBold, isItalic: isItalic)
    }
    
    init(
        size: CGFloat,
        isBold: Bool = false,
        isItalic: Bool = false
    ) {
        self.size = size
        self.isBold = isBold
        self.isItalic = isItalic
    }
    
    public func make(isBold: Bool = false, isItalic: Bool = false) -> UIFont {
        switch (isBold, isItalic) {
            case (false, false):
            return UIFont.systemFont(ofSize: size)
            case (true, false):
            return UIFont.boldSystemFont(ofSize: size)
            case (false, true):
            return UIFont.italicSystemFont(ofSize: size)
            case (true, true):
            return UIFont.systemFont(ofSize: size).with([.traitBold, .traitItalic])
        }
    }
}
