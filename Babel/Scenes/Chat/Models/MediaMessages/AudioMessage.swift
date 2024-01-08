import Foundation
import AVFoundation
import MessageKit

final class AudioMessage: NSObject, AudioItem {
    var url: URL
    var duration: Float
    var size: CGSize
    
    init(url: URL = URL(fileURLWithPath: String()), duration: Float) {
        self.url = url
        self.size = CGSize(width: 200, height: 52)
        self.duration = duration
    }
}
