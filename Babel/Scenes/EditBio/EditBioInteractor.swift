protocol EditBioInteracting: AnyObject {
    func saveUserToFirebase(user: User)
}

final class EditBioInteractor {
    private let service: EditBioServicing
    private let presenter: EditBioPresenting

    init(service: EditBioServicing, presenter: EditBioPresenting) {
        self.service = service
        self.presenter = presenter
    }
}

// MARK: - EditBioInteracting
extension EditBioInteractor: EditBioInteracting {
    func saveUserToFirebase(user: User) {
        service.saveUserToFirebase(user: user) { [weak self] error in
            guard let self else {
                return
            }
            if let error {
                self.presenter.displayErrorMessage(message: error.localizedDescription)
            }
        }
    }
}
