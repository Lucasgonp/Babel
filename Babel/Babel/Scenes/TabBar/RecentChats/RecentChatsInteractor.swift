import StorageKit

protocol RecentChatsInteracting: AnyObject {
    func loadRecentChats()
}

final class RecentChatsInteractor {
    private let service: RecentChatsServicing
    private let presenter: RecentChatsPresenting
    private var currentUser: User {
        AccountInfo.shared.user!
    }

    init(service: RecentChatsServicing, presenter: RecentChatsPresenting) {
        self.service = service
        self.presenter = presenter
    }
}

// MARK: - RecentChatsInteracting
extension RecentChatsInteractor: RecentChatsInteracting {
    func loadRecentChats() {
        service.downloadRecentChats(key: StorageKey.senderId.rawValue, currentUserId: currentUser.id) { [weak self] recentChats in
            self?.presenter.displayViewState(.success(recentChats: recentChats))
        }
    }
}
