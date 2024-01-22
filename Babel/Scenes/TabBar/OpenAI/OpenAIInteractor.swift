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
        let chatDTO = ChatBotDTO(
            id: kCHATBOT,
            chatId: chatRoomId,
            name: Strings.OpenAI.ChatBot.title,
            description: Strings.OpenAI.ChatBot.description,
            avatarImage: ChatBotHelper.Images.chatBotIcon
        )
        presenter.didNextStep(action: .pushChatBot(chatDTO))
    }
    
    func openImageGenerator() {
        let chatRoomId = ChatBotHelper.shared.createImageGeneratorRoomId()
        let chatDTO = ChatBotDTO(
            id: kIMAGEGENERATOR,
            chatId: chatRoomId,
            name: Strings.OpenAI.ChatBot.title,
            description: Strings.OpenAI.ImageGenerator.description,
            avatarImage: ChatBotHelper.Images.imageGeneratorIcon
        )
        presenter.didNextStep(action: .pushImageGenerator(chatDTO))
    }
}
