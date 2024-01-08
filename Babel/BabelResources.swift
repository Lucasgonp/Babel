import Foundation

final class BabelResources {
    static let resourcesBundle: Bundle = {
        let bundle = Bundle(for: BabelResources.self)
        guard let url = bundle.url(forResource: "BabelResources",
                                   withExtension: "bundle") else {
            return bundle
        }

        return Bundle(url: url) ?? bundle
    }()
}
