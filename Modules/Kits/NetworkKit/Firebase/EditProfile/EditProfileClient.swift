import FirebaseFirestore

public protocol EditProfileClientProtocol {
    func updateAvatarsOrigin(currentUserId: String, imageLink: String)
    func updateNameOrigin(currentUserId: String, name: String)
}

extension FirebaseClient: EditProfileClientProtocol {
    public func updateNameOrigin(currentUserId: String, name: String) {
        firebaseReference(.recent)
            .whereField("receiverId", isEqualTo: currentUserId).getDocuments { snapshot, error in
                snapshot?.query.whereField("type", isEqualTo: "chat").getDocuments(completion: { snapshot, error in
                    guard let documents = snapshot?.documents else {
                        return
                    }
                    
                    for document in documents {
                        let fields = ["receiverName": name]
                        document.reference.setData(fields, merge: true)
                    }
                })
            }
    }
    
    public func updateAvatarsOrigin(currentUserId: String, imageLink: String) {
        firebaseReference(.recent)
            .whereField("receiverId", isEqualTo: currentUserId).getDocuments { snapshot, error in
                snapshot?.query.whereField("type", isEqualTo: "chat").getDocuments(completion: { snapshot, error in
                    guard let documents = snapshot?.documents else {
                        return
                    }
                    
                    for document in documents {
                        let fields = ["avatarLink": imageLink]
                        document.reference.setData(fields, merge: true)
                    }
                })
            }
    }
}
