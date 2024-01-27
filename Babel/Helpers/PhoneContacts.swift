import Contacts

struct PhoneContacts {
    static let shared = PhoneContacts()
    private let store = CNContactStore()
    
    func requestAccess(completion: @escaping (_ accessGranted: Bool) -> Void) {
        let authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
        
        switch authorizationStatus {
        case .authorized:
            completion(true)
        default:
            store.requestAccess(for: .contacts, completionHandler: { (access, accessError) -> Void in
                completion(access)
            })
        }
    }
    
    func fetchContacts() -> [CNContact] {
        var allContainers = [CNContainer]()
        
        do {
            allContainers = try store.containers(matching: nil)
        } catch {
            print("something wrong happened")
        }
        
        var allContacts = [CNContact]()
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            let keysToFetch = [
                CNContactGivenNameKey,
                CNContactMiddleNameKey,
                CNContactFamilyNameKey,
                CNContactPhoneNumbersKey,
                CNContactImageDataKey
            ]
            do {
                let containerResults = try store.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as [CNKeyDescriptor])
                allContacts.append(contentsOf: containerResults)
            } catch {
                print("Error fetching containers")
            }
        }
        
        return allContacts
    }
}
