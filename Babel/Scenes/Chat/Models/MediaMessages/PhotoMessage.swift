import UIKit
import MessageKit
import DesignKit

final class PhotoMessage: NSObject, MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
    
    init(
        path: String,
        image: UIImage? = nil,
        placeholderImage: UIImage = UIImage()
    ) {
        self.url = URL(string: path)
        self.image = image
        self.placeholderImage = placeholderImage
        self.size = CGSize(width: 240, height: 240)
    }
}
