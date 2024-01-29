import FirebaseRemoteConfig
//import OpenAI

protocol ChatBotAIWorkerProtocol {
    func sendMessage(_ text: String, completion: @escaping (Result<String, Error>) -> Void)
}

final class ChatBotAIWorker {
//    private let client: OpenAI
//    
//    init(client: OpenAI = OpenAI(apiToken: RemoteConfigManager.shared.openAIToken)) {
//        self.client = client
//    }
}

extension ChatBotAIWorker: ChatBotAIWorkerProtocol {
    func sendMessage(_ text: String, completion: @escaping (Result<String, Error>) -> Void) {
//        let query = ChatQuery(model: .textEmbeddingAda, messages: [.init(role: .user, content: text)])
//        client.chats(query: query) { result in
//            switch result {
//            case let .success(model):
//                if let text = model.choices.first?.message.content {
//                    completion(.success(text))
//                }
//            case let .failure(error):
//                completion(.failure(error))
//            }
//        }
    }
}
