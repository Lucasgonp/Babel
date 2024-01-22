import FirebaseRemoteConfig

private let defaults: [String: NSObject] = [
    "OpenAIToken": "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" as NSObject,
    "ShowTabBots": false as NSObject
]

final class RemoteConfigManager {
    static let shared = RemoteConfigManager()
    
    private let remoteConfig: RemoteConfig = {
        let remoteConfig = RemoteConfig.remoteConfig()
        return remoteConfig
    }()
    
    private init() {
        setup()
    }
    
    var openAIToken: String {
        remoteConfig.configValue(forKey: Keys.OpenAIToken.rawValue)
            .stringValue ?? String()
    }
    
    var showTabBots: Bool {
        remoteConfig.configValue(forKey: Keys.ShowTabBots.rawValue).boolValue
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
          self?.remoteConfig.activate(completion: nil)
        }
    }
}
