import UIKit
import DesignKit

protocol TellAFriendDisplaying: AnyObject {
    func displaySomething()
}

private extension TellAFriendViewController.Layout {
    // example
    enum Size {
        static let imageHeight: CGFloat = 90.0
    }
}

final class TellAFriendViewController: ViewController<TellAFriendInteractorProtocol, UIView> {
    fileprivate enum Layout { }
    typealias Localizable = Strings.Settings.TellAFriend

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

// MARK: - TellAFriendDisplaying
extension TellAFriendViewController: TellAFriendDisplaying {
    func displaySomething() { 
        // template
    }
}
