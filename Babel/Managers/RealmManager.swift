import RealmSwift

final class RealmManager {
    static let shared = RealmManager()
    
    let realm = try! Realm()
    
    private init() { }
    
    func saveToRealm<T: Object>(_ object: T) {
        do {
            try realm.write { [weak self] in
                self?.realm.add(object, update: .modified)
            }
        } catch {
            print("error saving realm: \(error.localizedDescription)")
        }
    }
    
    func deleteAll() {
        do {
            try realm.write { [weak self] in
                self?.realm.deleteAll()
            }
        } catch {
            print("error saving realm: \(error.localizedDescription)")
        }
    }
}
