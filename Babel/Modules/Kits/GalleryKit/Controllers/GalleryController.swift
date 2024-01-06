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
                completion(items.singlePhoto?.image)
                picker.dismiss(animated: true)
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
                let mediaItems = self.makeMediaItems(from: items)
                completion(mediaItems)
                picker.dismiss(animated: true)
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
        case multimedia
        case `default`
        
        var picker: YPImagePicker {
            var config = YPImagePickerConfiguration()
            
            switch self {
            case .avatarPhoto:
                config.screens = [.library]
                config.library.onlySquare = true
                config.library.mediaType = .photo
                config.library.maxNumberOfItems = 1
                config.showsCrop = .circle
                
                return YPImagePicker(configuration: config)
            case .multimedia:
                config.library.mediaType = .photoAndVideo
                config.screens = [.library]
                config.maxNumberOfItems = 5
                config.video.compression = AVAssetExportPresetHighestQuality
                config.showsVideoTrimmer = true
                //                config.albumName = "Babel Images"
                //                config.video.recordingTimeLimit = 60.0
                config.video.libraryTimeLimit = 60.0
                config.video.minimumTimeLimit = 3.0
                config.video.trimmerMaxDuration = 60.0
                config.video.trimmerMinDuration = 1.0
                
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
