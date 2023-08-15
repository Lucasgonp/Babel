import UIKit

public enum Brand: String, CaseIterable {
    case brandLogo = "babel-brand-logo"

    var renderingMode: UIImage.RenderingMode {
        .alwaysOriginal
    }

    public var image: UIImage {
        let bundle = BundleToken.bundle
        let image = UIImage(named: self.rawValue, in: bundle, compatibleWith: nil)

        guard let result = image else {
            debugPrint("Unable to load image asset named \(self.rawValue).")
            return UIImage()
        }

        return result
    }
}
