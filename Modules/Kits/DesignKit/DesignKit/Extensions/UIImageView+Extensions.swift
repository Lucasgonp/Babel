//import UIKit
//
//extension UIImageView {
//    public static func icon(_ icon: UIImage, size: Image.IconSize = .medium, color: Color = Color.secondary800) -> UIImageView {
//        set(imageView: .init(image: icon), size: size.rawValue, color: color, withRenderingMode: icon.renderingMode)
//    }
//}
//
//private extension UIImageView {
//    static func set(imageView: UIImageView, size: CGSize, color: Color, withRenderingMode: UIImage.RenderingMode = .alwaysTemplate) -> UIImageView {
//        var image = imageView.image
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        image = imageView.image?.withRenderingMode(withRenderingMode)
//        
//        
//        if withRenderingMode != .alwaysOriginal {
//            image = image?.withTintColor(color.uiColor)
//        }
//        
//        imageView.image = image
//        if withRenderingMode != .alwaysOriginal {
//            imageView.tintColor = color.uiColor
//        }
//        
//        NSLayoutConstraint.activate([
//            imageView.widthAnchor.constraint(equalToConstant: size.width),
//            imageView.heightAnchor.constraint(equalToConstant: size.height)
//        ])
//        
//        return imageView
//    }
//}
