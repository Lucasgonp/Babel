import UIKit
import DesignKit

protocol UsersDisplaying: AnyObject {
    func displaySomething()
}

private extension UsersViewController.Layout {
    // example
    enum Size {
        static let imageHeight: CGFloat = 90.0
    }
}

final class UsersViewController: ViewController<UsersInteracting, UIView> {
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

// MARK: - UsersDisplaying
extension UsersViewController: UsersDisplaying {
    func displaySomething() { 
        // template
    }
}
