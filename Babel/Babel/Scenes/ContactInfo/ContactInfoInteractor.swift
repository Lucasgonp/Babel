protocol ContactInfoInteracting: AnyObject {
    func loadContactInfo()
}

final class ContactInfoInteractor {
    private let service: ContactInfoServicing
    private let presenter: ContactInfoPresenting
    private let contactInfo: User

    init(
        service: ContactInfoServicing,
        presenter: ContactInfoPresenting,
        contactInfo: User
    ) {
        self.service = service
        self.presenter = presenter
        self.contactInfo = contactInfo
    }
}

// MARK: - ContactInfoInteracting
extension ContactInfoInteractor: ContactInfoInteracting {
    func loadContactInfo() {
        presenter.displayViewState(.success(contact: contactInfo))
    }
}
