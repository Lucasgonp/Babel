import UIKit
import SDWebImage

extension UIImageView {
    public func setImage(with url: URL?, placeholderImage: UIImage? = nil, completion: (() -> Void)? = nil) {
        let activityIndicator = makeLoadingIndicator()
        activityIndicator.startAnimating()
        
        if let url {
            sd_setImage(with: url) { _, _, _, _ in
                completion?()
                activityIndicator.stopAnimating()
            }
        } else {
            image = placeholderImage
            completion?()
            activityIndicator.stopAnimating()
        }
    }
    
    public func setImage(with link: String?, placeholderImage: UIImage? = nil, completion: (() -> Void)? = nil) {
        let activityIndicator = makeLoadingIndicator()
        activityIndicator.startAnimating()
        
        if let link, let url = URL(string: link) {
            sd_setImage(with: url) { _, _, _, _ in
                completion?()
                activityIndicator.stopAnimating()
            }
        } else {
            image = placeholderImage
            completion?()
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
