import UIKit

extension UIAlertAction {
    convenience init(title: String?, style: UIAlertAction.Style, image : UIImage?, handler: ((UIAlertAction) -> Void)? = nil ){
        self.init(title: title, style: style, handler: handler)
        setValue(image, forKey: "image")
    }
}
