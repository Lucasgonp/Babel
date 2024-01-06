public enum MediaItem {
    case photo(MediaPhoto)
    case video(MediaVideo)
}

public extension Array where Element == MediaItem {
    var singlePhoto: MediaPhoto? {
        if let f = first, case let .photo(p) = f {
            return p
        }
        return nil
    }
    
    var singleVideo: MediaVideo? {
        if let f = first, case let .video(v) = f {
            return v
        }
        return nil
    }
}
