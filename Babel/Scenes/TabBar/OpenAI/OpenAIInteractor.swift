protocol OpenAIInteractorProtocol: AnyObject {
    func openChatBot()
    func openImageGenerator()
}

final class OpenAIInteractor {
    private let worker: OpenAIWorker
    private let presenter: OpenAIPresenterProtocol
    
    private var currentUser: User {
        UserSafe.shared.user
    }
    
    init(worker: OpenAIWorker, presenter: OpenAIPresenterProtocol) {
        self.worker = worker
        self.presenter = presenter
    }
}

extension OpenAIInteractor: OpenAIInteractorProtocol {
    func openChatBot() {
        let chatRoomId = ChatBotHelper.shared.createChatRoomId()
        presenter.didNextStep(action: .pushChatBot)
    }
    
    func openImageGenerator() {
        let chatRoomId = ChatBotHelper.shared.createImageGeneratorRoomId()
        presenter.didNextStep(action: .pushImageGenerator)
    }
}
