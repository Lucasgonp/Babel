import UIKit

private let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    public func setImage(with url: URL?, placeholderImage: UIImage? = nil, completion: ((UIImage?) -> Void)? = nil) {
        guard let url else {
            image = placeholderImage
            completion?(placeholderImage)
            return
        }
        
        /// Get image from cache
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            image = imageFromCache
            completion?(imageFromCache)
            return
        }
        
        /// Get image from local
        let fileName = StorageAdapter.shared.fileNameFrom(fileUrl: url.absoluteString) + ".png"
        if StorageAdapter.shared.fileExistsAtPath(path: fileName) {
            let fileDirectory = StorageAdapter.shared.fileInDocumentsDirectory(fileName: fileName)
            let image = UIImage(contentsOfFile: fileDirectory)
            self.image = image
            completion?(image)
            return
        }
        
        /// Get image from HTTP request
        let activityIndicator = makeLoadingIndicator()
        activityIndicator.startAnimating()
        DispatchQueue.global().async {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                DispatchQueue.main.async {
                    if let data, let image = UIImage(data: data) {
                        imageCache.setObject(image, forKey: url as AnyObject)
                        StorageAdapter.shared.saveFileLocally(fileData: data, fileName: fileName)
                        self?.image = image
                        completion?(image)
                    } else {
                        self?.image = placeholderImage
                        completion?(placeholderImage)
                    }
                    activityIndicator.stopAnimating()
                }
            }.resume()
        }
    }
    
    public func setImage(with link: String?, placeholderImage: UIImage? = nil, completion: ((UIImage?) -> Void)? = nil) {
        guard let link, let url = URL(string: link) else {
            image = placeholderImage
            completion?(placeholderImage)
            return
        }
        
        /// Get image from cache
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            image = imageFromCache
            completion?(imageFromCache)
            return
        }
        
        /// Get image from local
        let fileName = StorageAdapter.shared.fileNameFrom(fileUrl: link) + ".png"
        if StorageAdapter.shared.fileExistsAtPath(path: fileName) {
            let fileDirectory = StorageAdapter.shared.fileInDocumentsDirectory(fileName: fileName)
            let image = UIImage(contentsOfFile: fileDirectory)
            self.image = image
            completion?(image)
            return
        }
        
        /// Get image from HTTP request
        let activityIndicator = makeLoadingIndicator()
        activityIndicator.startAnimating()
        DispatchQueue.global().async {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                DispatchQueue.main.async {
                    if let data, let image = UIImage(data: data) {
                        imageCache.setObject(image, forKey: url as AnyObject)
                        StorageAdapter.shared.saveFileLocally(fileData: data, fileName: fileName)
                        self?.image = image
                        completion?(image)
                    } else {
                        self?.image = placeholderImage
                        completion?(placeholderImage)
                    }
                    activityIndicator.stopAnimating()
                }
            }.resume()
        }
    }
}

private extension UIImageView {
    func makeLoadingIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.heightAnchor.constraint(equalToConstant: 45),
            activityIndicator.widthAnchor.constraint(equalToConstant: 45),
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        return activityIndicator
    }
}

//extension UIImageView {
//    public func setImage(with url: URL?, placeholderImage: UIImage? = nil, completion: ((UIImage?) -> Void)? = nil) {
//        let activityIndicator = makeLoadingIndicator()
//        
//        if let url {
//            activityIndicator.startAnimating()
//            kf.setImage(with: url, placeholder: placeholderImage) { [weak self] response in
//                activityIndicator.stopAnimating()
//                
//                if case let .success(result) = response {
//                    self?.image = result.image
//                    completion?(result.image)
//                } else {
//                    self?.image = placeholderImage
//                    completion?(placeholderImage)
//                }
//            }
//        } else {
//            image = placeholderImage
//            completion?(placeholderImage)
//            activityIndicator.stopAnimating()
//        }
//    }
//    
//    public func setImage(with link: String?, placeholderImage: UIImage? = nil, completion: ((UIImage?) -> Void)? = nil) {
//        let activityIndicator = makeLoadingIndicator()
//        
//        if let link, let url = URL(string: link) {
//            activityIndicator.startAnimating()
//            kf.setImage(with: url, placeholder: placeholderImage) { [weak self] response in
//                activityIndicator.stopAnimating()
//                
//                if case let .success(result) = response {
//                    self?.image = result.image
//                    completion?(result.image)
//                } else {
//                    self?.image = placeholderImage
//                    completion?(placeholderImage)
//                }
//            }
//        } else {
//            image = placeholderImage
//            completion?(placeholderImage)
//            activityIndicator.stopAnimating()
//        }
//    }
//}
//
//private extension UIImageView {
//    func makeLoadingIndicator() -> UIActivityIndicatorView {
//        let activityIndicator = UIActivityIndicatorView()
//        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
//        
//        addSubview(activityIndicator)
//        
//        NSLayoutConstraint.activate([
//            activityIndicator.heightAnchor.constraint(equalToConstant: 45),
//            activityIndicator.widthAnchor.constraint(equalToConstant: 45),
//            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
//            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
//        ])
//        
//        return activityIndicator
//    }
//}

/*
 

 
 
 */
