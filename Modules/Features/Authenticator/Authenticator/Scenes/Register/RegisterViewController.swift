import UIKit
import DesignKit

protocol RegisterDisplaying: AnyObject {
    func displaySomething()
}

private extension RegisterViewController.Layout {
    // example
    enum Size {
        static let imageHeight: CGFloat = 90.0
    }
}

final class RegisterViewController: ViewController<RegisterInteracting, UIView> {
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

// MARK: - RegisterDisplaying
extension RegisterViewController: RegisterDisplaying {
    func displaySomething() {
        // template
    }
}
