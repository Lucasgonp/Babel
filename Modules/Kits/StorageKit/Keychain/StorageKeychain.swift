import Security

public struct StorageKeychain {
    static public let shared = StorageKeychain()
    
    public func saveLogin(email: String, password: String) {
        guard let passwordData = password.data(using: .utf8) else {
            return
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "babel.page.link",
            kSecAttrAccount as String: email,
            kSecValueData as String: passwordData,
        ]
        
        let saveStatus = SecItemAdd(query as CFDictionary, nil)
        if saveStatus == errSecDuplicateItem {
            updateLogin(email: email, password: password)
        }
    }

    private func updateLogin(email: String, password: String) {
        guard let passwordData = password.data(using: .utf8) else {
            return
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "babel.page.link",
            kSecAttrAccount as String: email
        ]
        
        let updatedData: [String: Any] = [
            kSecValueData as String: passwordData
        ]
        
        SecItemUpdate(query as CFDictionary, updatedData as CFDictionary)
    }
}
