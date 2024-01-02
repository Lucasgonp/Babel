import UIKit

extension UIAlertAction {
    @NSManaged var image : UIImage?
    
    convenience init(title: String?, style: UIAlertAction.Style, image : UIImage?, handler: ((UIAlertAction) -> Void)? = nil ){
        self.init(title: title, style: style, handler: handler)
        self.image = image
    }
}
