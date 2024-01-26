struct DeeplinkManager {
    enum Deeplink: String {
        case home
    }
    
    static func handleDeeplink(_ deeplink: Deeplink) {
        if case .home = deeplink {
            // TODO: All cases
        }
    }
}
