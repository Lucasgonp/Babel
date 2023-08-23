import UIKit
import DesignKit

protocol EditProfileDisplaying: AnyObject {
    func displaySomething()
}

private extension EditProfileViewController.Layout {
    // example
    enum Size {
        static let imageHeight: CGFloat = 90.0
    }
}

final class EditProfileViewController: ViewController<EditProfileInteracting, UIView> {
    fileprivate enum Layout { }
    typealias Localizable = Strings.Settings.EditProfile

    override func viewDidLoad() {
        super.viewDidLoad()

        interactor.loadSomething()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode =  .never
    }

    override func buildViewHierarchy() { 
        // template
    }
    
    override func setupConstraints() { 
        // template
    }

    override func configureViews() { 
        title = Localizable.title
        view.backgroundColor = Color.grayscale050.uiColor
    }
}

// MARK: - EditProfileDisplaying
extension EditProfileViewController: EditProfileDisplaying {
    func displaySomething() { 
        // template
    }
}
