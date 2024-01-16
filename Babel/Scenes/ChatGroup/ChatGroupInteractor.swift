import UIKit
import RealmSwift
import struct GalleryKit.MediaVideo

protocol ChatGroupInteracting: AnyObject {
    func loadChatMessages()
    func sendMessage(message: OutgoingMessage)
    func registerObservers()
    func removeListeners()
    func refreshNewMessages()
    func updateTypingObserver()
}

final class ChatGroupInteractor {
    typealias Localizable = Strings.ChatView
    
    private var currentUser: User {
        UserSafe.shared.user
    }
    
    //MARK: Init
    private let presenter: ChatGroupPresenting
    private var dto: ChatGroupDTO
    
    private var notificationToken: NotificationToken?
    
    //MARK: Typing
    private var typingCounter = 0
    
    //MARK: Audio
    private var audioFileName = String()
    private var audioDuration = Date()
    
    //MARK: Workers
    private let chatListenerWorker: ChatListenersWorkerProtocol
    private let chatTypingWorker: ChatTypingWorkerProtocol
    private let fetchMessageWorker: FetchMessageWorkerProtocol
    private let sendMessageWorker: SendMessageWorkerProtocol

    init(
        chatListenerWorker: ChatListenersWorkerProtocol = ChatListenersWorker(),
        chatTypingWorker: ChatTypingWorkerProtocol = ChatTypingWorker(),
        fetchMessageWorker: FetchMessageWorkerProtocol = FetchMessageWorker(),
        sendMessageWorker: SendMessageWorkerProtocol = SendMessageWorker(),
        presenter: ChatGroupPresenting,
        dto: ChatGroupDTO
    ) {
        self.chatListenerWorker = chatListenerWorker
        self.chatTypingWorker = chatTypingWorker
        self.fetchMessageWorker = fetchMessageWorker
        self.sendMessageWorker = sendMessageWorker
        self.presenter = presenter
        self.dto = dto
    }
}

extension ChatGroupInteractor: ChatGroupInteracting {
    func loadChatMessages() {
        let predicate = NSPredicate(format: "chatRoomId = %@", dto.chatId)
        dto.allLocalMessages = RealmManager.shared.realm.objects(LocalMessage.self).filter(predicate).sorted(byKeyPath: kDATE, ascending: true)
        
        if dto.allLocalMessages?.isEmpty == true {
            checkForOldChats()
        }
        
        notificationToken = dto.allLocalMessages?.observe({ [weak self] (changes: RealmCollectionChange) in
            guard let self else { return }
            switch changes {
            case .initial:
                self.insertMessages()
            case let .update(_, _, insertions, _):
                for index in insertions {
                    self.insertMessage(self.dto.allLocalMessages![index])
                }
            case let .error(error):
                fatalError("Error on new insertion \(error.localizedDescription)")
            }
        })
    }
    
    func registerObservers() {
        listenForNewChats()
        createTypingObserver()
        listenForReadStatusChange()
    }
    
    func removeListeners() {
        chatListenerWorker.removeListeners()
    }
    
    func sendMessage(message: OutgoingMessage) {
        let localMessage = LocalMessage()
        localMessage.id = UUID().uuidString
        localMessage.chatRoomId = message.chatId
        localMessage.senderId = currentUser.id
        localMessage.senderName = currentUser.name
        localMessage.senderInitials = "\(currentUser.name.first!)"
        localMessage.date = Date()
        localMessage.status = Localizable.sent
        localMessage.senderAvatarLink = currentUser.avatarLink
        
        if let text = message.text {
            sendTextMessage(message: localMessage, text: text, memberIds: message.memberIds)
        }
        
        if let data = message.photo, let photo = UIImage(data: data) {
            sendPhotoMessage(message: localMessage, image: photo, memberIds: message.memberIds)
        }
        
        if let video = message.video {
            sendVideoMessage(message: localMessage, video: video, memberIds: message.memberIds)
        }
        
        if let _ = message.location {
            sendLocationMessage(message: localMessage, memberIds: message.memberIds)
        }
        
        if let audio = message.audio {
            let audioDuration = Double(audioDuration.interval(ofComponent: .second, from: Date()))
            localMessage.audioDuration = audioDuration
            sendAudioMessage(message: localMessage, audioFileName: audio, audioDuration: audioDuration, memberIds: message.memberIds)
        }
        
        // TODO: Send push notification
        
        updateRecents(chatRoomId: dto.chatId, lastMessage: localMessage.message)
    }
    
    func refreshNewMessages() {
        if dto.displayingMessagesCount < dto.allLocalMessages?.count ?? 0 {
            loadMoreMessages(maxNumber: dto.maxMessageNumber, minNumber: dto.minMessageNumber)
            presenter.refreshNewMessages()
        } else {
            presenter.endRefreshing()
        }
    }
    
    func updateTypingObserver() {
        typingCounter += 1
        chatTypingWorker.saveTypingCounter(isTyping: true, chatRoomId: dto.chatId)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.typingCounterStop()
        }
    }
}

private extension ChatGroupInteractor {
    func checkForOldChats() {
        fetchMessageWorker.getOldChats(documentId: currentUser.id, collectionId: dto.chatId) { result in
            switch result {
            case var .success(messages):
                messages.sort(by: { $0.date < $1.date })
                messages.forEach({ RealmManager.shared.saveToRealm($0) })
                
            case let .failure(error):
                print("Error getting older chat: \(error.localizedDescription)")
                return
            }
        }
    }
    
    func insertMessages() {
        guard let allLocalMessages = dto.allLocalMessages else { return }
        
        dto.maxMessageNumber = (allLocalMessages.count) - dto.displayingMessagesCount
        dto.minMessageNumber = dto.maxMessageNumber - kNUMBEROFMESSAGES
        
        if dto.minMessageNumber < 0 {
            dto.minMessageNumber = 0
        }
        
        for i in dto.minMessageNumber ..< dto.maxMessageNumber {
            insertMessage(allLocalMessages[i])
        }
    }
    
    func insertMessage(_ localMessage: LocalMessage) {
        if localMessage.senderId != currentUser.id && localMessage.status != Localizable.read {
            markMessageAsRead(localMessage)
        }
        
        dto.displayingMessagesCount += 1
        presenter.displayMessage(localMessage)
    }
    
    func markMessageAsRead(_ localMessage: LocalMessage) {
        if !dto.membersIds.contains({ currentUser.id }()) {
            dto.membersIds.append(currentUser.id)
        }
        sendMessageWorker.updateMessageInFirebase(
            message: localMessage,
            dto: .init(
                chatRoomId: dto.chatId,
                messageId: localMessage.id,
                memberIds: dto.membersIds,
                status: [kSTATUS: Localizable.read, kREADDATE: Date()]
            )
        )
    }
    
    func listenForNewChats() {
        let date = dto.allLocalMessages?.last?.date ?? Date()
        let lastMessageDate = Calendar.current.date(byAdding: .second, value: 1, to: date) ?? date
        chatListenerWorker.listenForNewChats(documentId: currentUser.id, collectionId: dto.chatId, lastMessageDate: lastMessageDate) { [weak self] result in
            switch result {
            case let .success(message):
                if message.senderId != self?.currentUser.id {
                    RealmManager.shared.saveToRealm(message)
                }
                
            case let .failure(error):
                print("Error listening to chat: \(error.localizedDescription)")
                return
            }
        }
    }
    
    func createTypingObserver() {
        chatTypingWorker.createTypingObserver(chatRoomId: dto.chatId) { [weak self] isTyping in
            self?.presenter.updateTypingIndicator(isTyping)
        }
    }
    
    //MARK: Read message
    func listenForReadStatusChange() {
        chatListenerWorker.listenForReadStatusChange(currentUser.id, collectionId: dto.chatId) { [weak self] updatedMessage in
            if updatedMessage.status != Localizable.sent {
                self?.resetUnreadCount()
                self?.presenter.updateMessage(updatedMessage)
            }
        }
    }
    
    func resetUnreadCount() {
        fetchMessageWorker.getRecentChats(chatRoomId: dto.chatId) { recents in
            
            for recent in recents {
                var recent = recent
                if recent.receiverId == UserSafe.shared.user.id {
                    recent.unreadCounter = 0
                }
                
                ChatHelper.shared.saveRecent(id: recent.id, recentChat: recent)
            }
        }
    }
    
    func updateRecents(chatRoomId: String, lastMessage: String) {
        fetchMessageWorker.getRecentChats(chatRoomId: chatRoomId) { [weak self] recents in
            for recent in recents {
                self?.updateRecentItemWithNewMessage(recent: recent, lastMessage: lastMessage)
            }
        }
    }
    
    func updateRecentItemWithNewMessage(recent: RecentChatModel, lastMessage: String) {
        var tempRecent = recent
        if tempRecent.senderId != UserSafe.shared.user.id {
            tempRecent.unreadCounter += 1
        }
        
        tempRecent.lastMassage = lastMessage
        tempRecent.receiverName = currentUser.name
//        tempRecent.membersId = dto.groupInfo.members.compactMap({ $0.id })
        tempRecent.date = Date()
        
        ChatHelper.shared.saveRecent(id: tempRecent.id, recentChat: tempRecent)
    }
    
    func loadMoreMessages(maxNumber: Int, minNumber: Int) {
        dto.maxMessageNumber = minNumber - 1
        dto.minMessageNumber = dto.maxMessageNumber - kNUMBEROFMESSAGES
        
        if dto.minMessageNumber < 0 {
            dto.minMessageNumber = 0
        }
        
        for i in (dto.minMessageNumber ... dto.maxMessageNumber).reversed() {
            dto.displayingMessagesCount += 1
            presenter.displayRefreshedMessages(dto.allLocalMessages![i])
        }
    }
    
    func typingCounterStop() {
        typingCounter -= 1
        if typingCounter == .zero {
            chatTypingWorker.saveTypingCounter(isTyping: false, chatRoomId: dto.chatId)
        }
    }
}

// MARK: Send Messages
private extension ChatGroupInteractor {
    func sendTextMessage(message: LocalMessage, text: String, memberIds: [String]) {
        message.message = text
        message.type = ChatMessageType.text.rawValue
        
        sendMessageWorker.addMessage(message, memberIds: memberIds)
    }
    
    func sendPhotoMessage(message: LocalMessage, image: UIImage, memberIds: [String]) {
        message.message = kPICTUREMESSAGE
        message.type = ChatMessageType.photo.rawValue
        
        let fileName = Date().stringDate()
        let directory = FileDirectory.uploadNewImage.format(message.chatRoomId, fileName)
        StorageManager.shared.uploadImage(image, directory: directory) { [weak self] imageURL in
            if let imageURL {
                message.pictureUrl = imageURL
                self?.sendMessageWorker.addMessage(message, memberIds: memberIds)
            }
        }
    }
    
    func sendVideoMessage(message: LocalMessage, video: MediaVideo, memberIds: [String]) {
        message.message = kVIDEOMESSAGE
        message.type = ChatMessageType.video.rawValue
        
        let fileName = Date().stringDate()
        let thumbnailDirectory = FileDirectory.videoThumbnail.format(message.chatRoomId, fileName)
        
        let thumbnail = video.makeYPMediaVideo().thumbnail
        
        StorageManager.shared.uploadImage(thumbnail, directory: thumbnailDirectory) { [weak self] thumbnailLink in
            if let thumbnailLink {
                self?.uploadVideo(
                    video,
                    thumbnailLink: thumbnailLink,
                    message: message,
                    fileName: fileName,
                    memberIds: memberIds
                )
            }
        }
    }
    
    func uploadVideo(
        _ video: MediaVideo,
        thumbnailLink: String,
        message: LocalMessage,
        fileName: String,
        memberIds: [String]
    ) {
        let videoDirectory = FileDirectory.video.format(message.chatRoomId, fileName)
        
        do {
            let videoData = try Data(contentsOf: video.videoURL)
            StorageManager.shared.saveFileLocally(fileData: videoData, fileName: fileName)
            StorageManager.shared.uploadVideo(videoData, directory: videoDirectory) { [weak self] videoLink in
                message.pictureUrl = thumbnailLink
                message.videoUrl = videoLink!
                
                self?.sendMessageWorker.addMessage(message, memberIds: memberIds)
            }
        } catch let error {
            fatalError("error trying to convert videoURL to Data: \(error.localizedDescription)")
        }
    }
    
    func sendLocationMessage(message: LocalMessage, memberIds: [String]) {
        let currentLocation = LocationManager.shared.currentLocation!
        
        message.message = kLOCATIONMESSAGE
        message.type = ChatMessageType.location.rawValue
        message.latitude = currentLocation.latitude
        message.longitude = currentLocation.longitude
        
        LocationManager.shared.stopUpdating()
        sendMessageWorker.addMessage(message, memberIds: memberIds)
    }
    
    func sendAudioMessage(message: LocalMessage, audioFileName: String, audioDuration: Double, memberIds: [String]) {
        message.message = kAUDIOMESSAGE
        message.type = ChatMessageType.audio.rawValue
        
        let fireDirectory = FileDirectory.audio.format(dto.chatId, audioFileName)
        StorageManager.shared.uploadAudio(audioFileName, directory: fireDirectory) { [weak self] audioLink in
            if let audioLink {
                message.audioUrl = audioLink
                message.audioDuration = audioDuration
                
                self?.sendMessageWorker.addMessage(message, memberIds: memberIds)
            }
        }
    }
}
