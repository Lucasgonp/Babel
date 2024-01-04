import UIKit
import DesignKit
import YPImagePicker
import AVFoundation

public final class GalleryController {
    private let picker: YPImagePicker
    
    public init(configuration: Configuration) {
        self.picker = configuration.picker
    }
    
    public func showSinglePhotoPicker(from navigation: UINavigationController?, completion: @escaping (UIImage?) -> Void) {
        picker.didFinishPicking { [unowned picker] items, cancelled in
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
            
            picker.dismiss(animated: true, completion: nil)
        }
        
        DispatchQueue.main.async { [unowned picker] in
            navigation?.present(picker, animated: true)
        }
    }
    
    public func showSingleMediaPicker(
        from navigation: UINavigationController?,
        loadingViewDelegate: LoadingViewDelegate? = nil,
        completion: @escaping (Data?) -> Void
    ) {
        picker.didFinishPicking { [unowned picker] items, cancelled in
            if cancelled {
                picker.dismiss(animated: true) {
                    completion(nil)
                }
            }
            
            if let item = items.singlePhoto {
                //                    print("fromCamera: \(item.fromCamera)") // Image source (camera or library)
                //                    print("image: \(item.image)") // Final image selected by the user
                //                    print("originalImage: \(item.originalImage)") // original image selected by the user, unfiltered
                //                    print("modifiedImage: \(item.modifiedImage)") // Transformed image, can be nil
                //                    print("exifMeta: \(item.exifMeta!)") // Print exif meta data of original image.
                completion(item.image.pngData())
            }
            
            if let item = items.singleVideo {
                //                print("fromCamera: \(item.fromCamera)")
                //                print("thumbnail: \(item.thumbnail)")
                //                print("url: \(item.url)")
                item.fetchData(completion: completion)
            }
        }
        
        DispatchQueue.main.async { [unowned picker] in
            navigation?.present(picker, animated: true) { [weak loadingViewDelegate] in
                loadingViewDelegate?.dismissLoadingView()
            }
        }
    }
}

public extension GalleryController {
    enum Configuration {
        case avatarPhoto
        case singlemedia
        
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
            case .singlemedia:
                config.library.mediaType = .photoAndVideo
                config.library.maxNumberOfItems = 1
                config.showsPhotoFilters = false
                config.screens = [.library]
                
                config.video.compression = AVAssetExportPresetHighestQuality
                config.video.fileType = .mov
                config.showsVideoTrimmer = true
//                config.albumName = "Babel Images"
                config.video.recordingTimeLimit = 60.0
                config.video.libraryTimeLimit = 60.0
                config.video.minimumTimeLimit = 3.0
                config.video.trimmerMaxDuration = 60.0
                config.video.trimmerMinDuration = 1.0
                
                return YPImagePicker(configuration: config)
            }
        }
    }
}
