import UIKit
import Photos
import YPImagePicker

public struct MediaVideo: Encodable {
    public var thumbnail: Data
    public var videoURL: URL
    public let fromCamera: Bool
    public var asset: String?
    
    init(thumbnail: UIImage, videoURL: URL, fromCamera: Bool, asset: PHAsset? = nil) {
        self.thumbnail = thumbnail.pngData() ?? Data()
        self.videoURL = videoURL
        self.fromCamera = fromCamera
        self.asset = asset?.localIdentifier
    }
    
    public func makeYPMediaVideo() -> YPMediaVideo {
        YPMediaVideo(
            thumbnail: UIImage(data: thumbnail) ?? UIImage(),
            videoURL: videoURL,
            fromCamera: fromCamera,
            asset: PHAsset.fetchAssets(withLocalIdentifiers: [asset ?? String()], options: nil).firstObject
        )
    }
}

public extension MediaVideo {
    /// Fetches a video data with selected compression in Configuration
    func fetchData(completion: (_ videoData: Data) -> Void) {
        // TODO: place here a compression code. Use YPConfig.videoCompression
        // and YPConfig.videoExtension
        completion(Data())
    }
}
