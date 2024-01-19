protocol SystemSettingsInteracting: AnyObject {
    func clearCache()
}

final class SystemSettingsInteractor {
    private let worker: SystemSettingsWorkerProtocol
    private let presenter: SystemSettingsPresenting

    init(worker: SystemSettingsWorkerProtocol, presenter: SystemSettingsPresenting) {
        self.worker = worker
        self.presenter = presenter
    }
}

extension SystemSettingsInteractor: SystemSettingsInteracting {
    func clearCache() {
        RealmManager.shared.deleteAll()
        presenter.didNextStep(action: .popViewController)
    }
}
