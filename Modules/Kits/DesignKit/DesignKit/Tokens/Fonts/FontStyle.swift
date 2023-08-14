import UIKit

public protocol FontStyle {
    var size: CGFloat { get }
    var isBold: Bool { get set }
    var isItalic: Bool { get set }
}
