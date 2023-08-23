protocol EditProfileInteracting: AnyObject {
    func loadSomething()
}

final class EditProfileInteractor {
    private let service: EditProfileServicing
    private let presenter: EditProfilePresenting
    private let user: User
    
    init(
        service: EditProfileServicing,
        presenter: EditProfilePresenting,
        user: User
    ) {
        self.service = service
        self.presenter = presenter
        self.user = user
    }
}

// MARK: - EditProfileInteracting
extension EditProfileInteractor: EditProfileInteracting {
    func loadSomething() {
        presenter.displaySomething()
    }
}
