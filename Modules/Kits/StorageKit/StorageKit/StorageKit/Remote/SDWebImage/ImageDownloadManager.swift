import UIKit
import SDWebImage

extension UIImageView {
    public func setAvatar(imageUrl: String, placeholderImage: UIImage? = nil, completion: (() -> Void)? = nil) {
        let activityIndicator = makeLoadingIndicator()
        activityIndicator.startAnimating()
        
        if let url = URL(string: imageUrl) {
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
