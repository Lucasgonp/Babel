import UIKit
import YPImagePicker
 
public struct GalleryController {
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
        
        // FIXME: Check retain cycle
        DispatchQueue.main.async {
            navigation?.present(picker, animated: true)
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
                config.showsPhotoFilters = true
                config.screens = [.library]
                config.library.onlySquare = true
//                config.library.isSquareByDefault = true
                config.library.mediaType = .photo
                config.library.maxNumberOfItems = 1
                config.showsCrop = .circle
//                config.showsCropGridOverlay = true
//                config.library.itemOverlayType = .grid
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
