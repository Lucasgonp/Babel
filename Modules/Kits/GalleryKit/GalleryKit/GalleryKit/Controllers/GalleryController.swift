import UIKit
import YPImagePicker
 
public final class GalleryController {
    private let picker: YPImagePicker
    
    public init(configuration: Configuration) {
        self.picker = configuration.picker
    }
    
    public func showSinglePhotoPicker(from navigation: UINavigationController?, completion: @escaping (UIImage?) -> Void) {
        picker.didFinishPicking { [weak picker] items, cancelled in
            if cancelled {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
            
            if let item = items.singlePhoto {
                DispatchQueue.main.async {
                    completion(item.image)
                }
            }
            
            picker?.dismiss(animated: true, completion: nil)
        }
        
        DispatchQueue.main.async { [unowned self] in
            navigation?.present(self.picker, animated: true)
        }
    }
}

public extension GalleryController {
    enum Configuration {
        case avatarPhoto
        case singlePhoto
        
        var picker: YPImagePicker {
            var config = YPImagePickerConfiguration()
            
            switch self {
            case .avatarPhoto:
                config.showsPhotoFilters = false
                config.screens = [.library]
                config.library.onlySquare = true
                config.library.mediaType = .photo
                config.library.maxNumberOfItems = 1
                config.showsCrop = .circle
                return YPImagePicker(configuration: config)
            case .singlePhoto:
                config.showsPhotoFilters = false
                config.screens = [.library]
                config.library.maxNumberOfItems = 1
                return YPImagePicker(configuration: config)
            }
        }
    }
}
