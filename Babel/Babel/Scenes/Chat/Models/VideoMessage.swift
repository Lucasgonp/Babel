import UIKit
import MessageKit
import DesignKit

final class VideoMessage: NSObject, MediaItem {
    var url: URL?
    var image: UIImage?
    var thumbailUrl: String
    var placeholderImage: UIImage
    var size: CGSize
    
    init(url: URL?, thumbailUrl: String) {
        self.url = url
        self.thumbailUrl = thumbailUrl
        self.placeholderImage = Image.photoPlaceholder.image
        self.size = CGSize(width: 240, height: 240)
    }
}
