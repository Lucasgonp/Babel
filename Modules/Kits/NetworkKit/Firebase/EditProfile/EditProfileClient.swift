import FirebaseFirestore

public protocol EditProfileClientProtocol {
    func updateAvatarsOrigin(currentUserId: String, imageLink: String)
}

extension FirebaseClient: EditProfileClientProtocol {
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
