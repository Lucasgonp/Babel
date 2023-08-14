import Foundation

final class AuthenticatorResources {
    static let resourcesBundle: Bundle = {
        let bundle = Bundle(for: AuthenticatorResources.self)
        guard let url = bundle.url(forResource: "AuthenticatorResources",
                                   withExtension: "bundle") else {
            return bundle
        }

        return Bundle(url: url) ?? bundle
    }()
}
