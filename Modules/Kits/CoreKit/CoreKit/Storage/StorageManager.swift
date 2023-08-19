public struct StorageManager {
    public static let shared = StorageManager()
    
    private init() {}
    
    public func getStorageObject<T: Decodable>(for key: StorageKey) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key.rawValue) else {
            print("Error retreaving data from storage, type: \(T.self), for key: \(key.rawValue)")
            return nil
        }
        
        do {
            let object = try JSONDecoder().decode(T.self, from: data)
            return object
        } catch let error {
            print("Error loading data into storage: \(error.localizedDescription)")
            return nil
        }
    }
    
    public func saveStorageData(_ data: Encodable, key: StorageKey) {
        do {
            let object = try JSONEncoder().encode(data)
            UserDefaults.standard.set(object, forKey: key.rawValue)
        } catch let error {
            print("Error saving data into storage: \(error.localizedDescription)")
        }
    }
    
    public func removeStorageData(key: StorageKey) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
}
