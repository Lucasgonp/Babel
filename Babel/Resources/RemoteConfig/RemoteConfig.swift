import FirebaseRemoteConfig

private let defaults: [String: NSObject] = [
    "OpenAIToken": String() as NSObject,
    "ShowTabBots": false as NSObject,
    "ShareAppMessage": "Let's chat on Babel! It's a fast, simple, and secure app we can use to message each other for free." as NSObject,
    "KeyServerFirebase": String() as NSObject
]

final class RemoteConfigManager {
    static let shared = RemoteConfigManager()
    
    private let remoteConfig: RemoteConfig = {
        let remoteConfig = RemoteConfig.remoteConfig()
        return remoteConfig
    }()
    
    var configTabBarHandler: (() -> Void)?
    
    private init() {
        setup()
    }
    
    var openAIToken: String {
        remoteConfig.configValue(forKey: Keys.OpenAIToken.rawValue)
            .stringValue ?? String()
    }
    
    var showTabBots: Bool {
        remoteConfig.configValue(forKey: Keys.ShowTabBots.rawValue)
            .boolValue
    }
    
    var shareAppMessage: String {
        remoteConfig.configValue(forKey: Keys.ShareAppMessage.rawValue)
            .stringValue ?? String()
    }
    
    var keyServerFirebase: String {
        remoteConfig.configValue(forKey: Keys.KeyServerFirebase.rawValue)
            .stringValue ?? String()
    }
}

private extension RemoteConfigManager {
    func setup() {
        remoteConfig.setDefaults(defaults)
        
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        remoteConfig.fetch { [weak self] status, error in
            if let error {
                print("remote config error: \(error.localizedDescription)")
            } else {
                self?.remoteConfig.activate(completion: nil)
            }
        }
        
        remoteConfig.addOnConfigUpdateListener { [weak self] configUpdate, error in
            guard let configUpdate, error == nil else { return }
            print("Updated keys: \(configUpdate.updatedKeys)")
            self?.remoteConfig.activate(completion: { [weak self] _, _ in
                if configUpdate.updatedKeys.contains("ShowTabBots") {
                    self?.configTabBarHandler?()
                }
            })
        }
    }
}
