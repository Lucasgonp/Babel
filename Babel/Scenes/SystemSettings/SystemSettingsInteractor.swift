protocol SystemSettingsInteractorProtocol: AnyObject {
    func clearCache()
}

final class SystemSettingsInteractor {
    private let worker: SystemSettingsWorkerProtocol
    private let presenter: SystemSettingsPresenterProtocol

    init(worker: SystemSettingsWorkerProtocol, presenter: SystemSettingsPresenterProtocol) {
        self.worker = worker
        self.presenter = presenter
    }
}

extension SystemSettingsInteractor: SystemSettingsInteractorProtocol {
    func clearCache() {
        RealmManager.shared.deleteAll()
        presenter.didNextStep(action: .popViewController)
    }
}
