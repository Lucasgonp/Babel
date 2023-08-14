import UIKit

extension UIImageView {
    public static func icon(_ icon: Icon, size: Icon.Size = .medium, color: Color = Color.secondary800) -> UIImageView {
        set(imageView: .init(image: icon.image), size: size.rawValue, color: color, withRenderingMode: icon.renderingMode)
    }
    
    private static func set(imageView: UIImageView, size: CGSize, color: Color, withRenderingMode: UIImage.RenderingMode = .alwaysTemplate) -> UIImageView {
        var image = imageView.image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        image = imageView.image?.withRenderingMode(withRenderingMode)

        if #available(iOS 13.0, *) {
            if withRenderingMode != .alwaysOriginal {
                image = image?.withTintColor(color.uiColor)
            }
        }
        imageView.image = image
        if withRenderingMode != .alwaysOriginal {
            imageView.tintColor = color.uiColor
        }

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: size.width),
            imageView.heightAnchor.constraint(equalToConstant: size.height)
        ])

        return imageView
    }
}
