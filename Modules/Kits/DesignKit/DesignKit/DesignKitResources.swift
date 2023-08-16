import Foundation

final class DesignKitResources {
    static let resourcesBundle: Bundle = {
        let bundle = Bundle(for: DesignKitResources.self)
        guard let url = bundle.url(forResource: "DesignKitResources",
                                   withExtension: "bundle") else {
            return bundle
        }

        return Bundle(url: url) ?? bundle
    }()
}
