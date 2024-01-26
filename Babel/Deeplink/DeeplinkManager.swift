struct DeeplinkManager {
    enum Deeplink: String {
        case home
        case chat
        case group
    }
    
    static func handleDeeplink(_ deeplink: Deeplink) {
        switch deeplink {
        case .home:
            return
        case .chat:
            <#code#>
        case .group:
            <#code#>
        }
    }
}
