import UIKit
import DesignKit
import YPImagePicker
import AVFoundation

public final class GalleryController {
    private lazy var picker = configuration.picker
    
    public var configuration: Configuration = .default {
        didSet {
            picker = configuration.picker
        }
    }
    
    public init() { }
    
    public func showSinglePhotoPicker(
        from navigation: UINavigationController?,
        completion: @escaping (UIImage?) -> Void
    ) {
        picker.didFinishPicking { [unowned picker] items, cancelled in
            DispatchQueue.main.async {
                picker.dismiss(animated: true) {
                    completion(items.singlePhoto?.image)
                }
            }
        }
        
        DispatchQueue.main.async { [unowned picker] in
            navigation?.present(picker, animated: true)
        }
    }
    
    public func showMediaPicker(
        from navigation: UINavigationController?,
        loadingViewDelegate: LoadingViewDelegate? = nil,
        completion: @escaping ([MediaItem]) -> Void
    ) {
        picker.didFinishPicking { [unowned picker, self] items, isCancelled in
            DispatchQueue.main.async {
                picker.dismiss(animated: true) {
                    let mediaItems = self.makeMediaItems(from: items)
                    completion(mediaItems)
                }
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
        case camera
        case avatarPhoto
        case library
        case cameraAndLibrary(numberOfItems: Int)
        case `default`
        
        var picker: YPImagePicker {
            var config = YPImagePickerConfiguration()
            config.shouldSaveNewPicturesToAlbum = false
            config.showsVideoTrimmer = true
            config.library.maxNumberOfItems = 1
            config.video.libraryTimeLimit = 60.0
            config.video.minimumTimeLimit = 3.0
            config.video.trimmerMaxDuration = 60.0
            config.video.trimmerMinDuration = 1.0
            config.video.recordingTimeLimit = 60.0
            config.video.compression = AVAssetExportPresetHighestQuality
            
            switch self {
            case .camera:
                config.screens = [.photo, .video]
                config.showsVideoTrimmer = true
                config.shouldSaveNewPicturesToAlbum = true
                config.albumName = "Babel Images"
                return YPImagePicker(configuration: config)
                
            case .avatarPhoto:
                config.screens = [.library, .photo]
                config.library.mediaType = .photo
                config.showsCrop = .circle
                return YPImagePicker(configuration: config)
                
            case .library:
                config.library.mediaType = .photoAndVideo
                config.screens = [.library]
                return YPImagePicker(configuration: config)
                
            case let .cameraAndLibrary(maxNumberOfItems):
                config.library.mediaType = .photoAndVideo
                config.screens = [.library, .photo, .video]
                config.library.maxNumberOfItems = maxNumberOfItems
                return YPImagePicker(configuration: config)
                
            default:
                return YPImagePicker(configuration: config)
            }
        }
    }
}

private extension GalleryController {
    func makeMediaItems(from ypMediaItems: [YPMediaItem]) -> [MediaItem] {
        return ypMediaItems.compactMap({
            switch $0 {
            case let .photo(mediaPhoto):
                return .photo(MediaPhoto(
                    originalImage: mediaPhoto.originalImage,
                    modifiedImage: mediaPhoto.modifiedImage,
                    fromCamera: mediaPhoto.fromCamera,
                    exifMeta: mediaPhoto.exifMeta,
                    asset: mediaPhoto.asset,
                    url: mediaPhoto.url
                ))
            case let .video(mediaVideo):
                return .video(MediaVideo(
                    thumbnail: mediaVideo.thumbnail,
                    videoURL: mediaVideo.url,
                    fromCamera: mediaVideo.fromCamera,
                    asset: mediaVideo.asset
                ))
            }
        })
    }
}
