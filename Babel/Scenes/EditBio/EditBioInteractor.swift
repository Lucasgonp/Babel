protocol EditBioInteractorProtocol: AnyObject {
    func saveUserToFirebase(user: User)
}

final class EditBioInteractor {
    private let service: EditBioWorkerProtocol
    private let presenter: EditBioPresenterProtocol

    init(service: EditBioWorkerProtocol, presenter: EditBioPresenterProtocol) {
        self.service = service
        self.presenter = presenter
    }
}

extension EditBioInteractor: EditBioInteractorProtocol {
    func saveUserToFirebase(user: User) {
        service.saveUserToFirebase(user: user) { [weak self] error in
            guard let self else { return }
            if let error {
                self.presenter.displayErrorMessage(message: error.localizedDescription)
            }
        }
    }
}
