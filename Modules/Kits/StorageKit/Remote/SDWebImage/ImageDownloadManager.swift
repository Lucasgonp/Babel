import UIKit
import SDWebImage

extension UIImageView {
    public func setImage(with url: URL?, placeholderImage: UIImage? = nil, completion: ((UIImage?) -> Void)? = nil) {
        let activityIndicator = makeLoadingIndicator()
        activityIndicator.startAnimating()
        
        if let url {
            sd_setImage(with: url) { [weak self] image, _, _, _ in
                if let image {
                    completion?(image)
                } else {
                    self?.image = placeholderImage
                    completion?(placeholderImage)
                }
                activityIndicator.stopAnimating()
            }
        } else {
            image = placeholderImage
            completion?(placeholderImage)
            activityIndicator.stopAnimating()
        }
    }
    
    public func setImage(with link: String?, placeholderImage: UIImage? = nil, completion: ((UIImage?) -> Void)? = nil) {
        let activityIndicator = makeLoadingIndicator()
        activityIndicator.startAnimating()
        
        if let link, let url = URL(string: link) {
            DispatchQueue.global().async {
                SDWebImageManager.shared.loadImage(with: url, progress: nil) { [weak self] image, _, _, _, _, _ in
                    DispatchQueue.main.async {
                        if let image {
                            completion?(image)
                        } else {
                            self?.image = placeholderImage
                            completion?(placeholderImage)
                        }
                        activityIndicator.stopAnimating()
                    }
                }
            }
        } else {
            image = placeholderImage
            completion?(placeholderImage)
            activityIndicator.stopAnimating()
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
