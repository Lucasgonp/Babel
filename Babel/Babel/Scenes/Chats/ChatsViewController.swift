import UIKit
import DesignKit

protocol ChatsDisplaying: AnyObject {
    func displaySomething()
}

private extension ChatsViewController.Layout {
    // example
    enum Size {
        static let imageHeight: CGFloat = 90.0
    }
}

final class ChatsViewController: ViewController<ChatsInteracting, UIView> {
    fileprivate enum Layout { 
        // template
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        interactor.loadSomething()
    }

    override func buildViewHierarchy() { 
        // template
    }
    
    override func setupConstraints() { 
        // template
    }

    override func configureViews() { 
        // template
    }
}

// MARK: - ChatsDisplaying
extension ChatsViewController: ChatsDisplaying {
    func displaySomething() { 
        // template
    }
}
