import UIKit

public enum Icon: String, CaseIterable {
    case feedbackDanger = "feedback-danger"

    var renderingMode: UIImage.RenderingMode {
        return .alwaysOriginal
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

    public enum Size: RawRepresentable {
        case large
        case medium

        public init?(rawValue: CGSize) {
            switch (rawValue.width, rawValue.height) {
            case (16, 16):
                self = .medium
            case (24, 24):
                self = .large
            default:
                self = .medium
            }
        }

        public var rawValue: CGSize {
            switch self {
            case .large:
                return .init(width: 24, height: 24)
            case .medium:
                return .init(width: 16, height: 16)
            }
        }
    }
}
