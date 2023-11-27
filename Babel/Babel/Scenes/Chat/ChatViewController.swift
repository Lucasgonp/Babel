import UIKit
import DesignKit
import MessageKit
import InputBarAccessoryView
import GalleryKit
import RealmSwift

protocol ChatDisplaying: AnyObject {
    func displaySomething()
}

private extension ChatViewController.Layout {
    // example
    enum Size {
        static let imageHeight: CGFloat = 90.0
    }
}

final class ChatViewController: MessagesViewController {
    fileprivate enum Layout {
        // template
    }
    
    private let interactor: ChatInteracting
    private let dto: ChatDTO
    
    init(interactor: ChatInteracting, dto: ChatDTO) {
        self.interactor = interactor
        self.dto = dto
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
        interactor.loadSomething()
    }
}

extension ChatViewController: ViewConfiguration {
    func buildViewHierarchy() {
        // template
    }
    
    func setupConstraints() {
        // template
    }

    func configureViews() {
        title = dto.recipientName
    }
}

// MARK: - ChatDisplaying
extension ChatViewController: ChatDisplaying {
    func displaySomething() { 
        // template
    }
}
