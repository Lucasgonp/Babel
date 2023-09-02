import UIKit

public class ImageView: UIImageView {
    public init(image: UIImage, size: CGSize? = nil, color: Color? = nil) {
        super.init(image: image)
        set(uiImage: image, size: size, color: color, withRenderingMode: image.renderingMode)
    }
    
    public init(icon: UIImage, size: Image.IconSize = .medium, color: Color? = nil) {
        super.init(image: icon)
        set(uiImage: icon, size: size.rawValue, color: color, withRenderingMode: icon.renderingMode)
    }
    
    public init() {
        super.init(frame: .zero)
    }
    
    public override init(image: UIImage?) {
        super.init(image: image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var intrinsicContentSize: CGSize {
        if let myImage = self.image {
            let myImageWidth = myImage.size.width
            let myImageHeight = myImage.size.height
            let myViewWidth = self.frame.size.width
 
            let ratio = myViewWidth/myImageWidth
            let scaledHeight = myImageHeight * ratio

            return CGSize(width: myViewWidth, height: scaledHeight)
        }

        return CGSize(width: -1.0, height: -1.0)
    }
}

private extension ImageView {
    func set(uiImage: UIImage, size: CGSize?, color: Color? = nil, withRenderingMode: UIImage.RenderingMode = .alwaysTemplate) {
        translatesAutoresizingMaskIntoConstraints = false
        uiImage.withRenderingMode(withRenderingMode)
        
        image = uiImage
        
        if let color {
            if withRenderingMode != .alwaysOriginal {
                image = uiImage.withTintColor(color.uiColor)
            }
            
            if withRenderingMode != .alwaysOriginal {
                tintColor = color.uiColor
            }
        }
        
        let size = size ?? intrinsicContentSize
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: size.width),
            heightAnchor.constraint(equalToConstant: size.height)
        ])
    }
}
