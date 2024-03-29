public struct StorageLocal {
    public static let shared = StorageLocal()
    private let storage: UserDefaults
    
    private init(storage: UserDefaults = .standard) {
        self.storage = storage
    }
    
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
    
    public func saveBool(_ bool: Bool, key: String) {
        UserDefaults.standard.set(bool, forKey: key)
    }
    
    public func getBool(key: String) -> Bool {
        UserDefaults.standard.bool(forKey: key)
    }
    
    public func saveStorage(_ data: Encodable, key: String) {
        do {
            let object = try JSONEncoder().encode(data)
            UserDefaults.standard.set(object, forKey: key)
        } catch {
            print("Error saving data into storage: \(error.localizedDescription)")
        }
    }
    
    public func getStorageObject<T: Decodable>(for key: String) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            print("Error retreaving data from storage, type: \(T.self), for key: \(key)")
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
    
    public func removeStorage(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    public func removeStorageData(key: StorageKey) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
    
    public func saveString(_ string: String, key: String) {
        UserDefaults.standard.set(string, forKey: key)
    }
    
    public func getString(key: String) -> String? {
        UserDefaults.standard.string(forKey: key)
    }
}
