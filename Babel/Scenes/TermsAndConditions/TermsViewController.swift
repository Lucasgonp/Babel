import UIKit
import DesignKit

protocol TermsDisplaying: AnyObject {
    func displaySomething()
}

private extension TermsViewController.Layout {
    // example
    enum Size {
        static let imageHeight: CGFloat = 90.0
    }
}

final class TermsViewController: ViewController<TermsInteractorProtocol, UIView> {
    fileprivate enum Layout { }
    typealias Localizable = Strings.Settings.TermsAndConditions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        interactor.loadSomething()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
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

// MARK: - TermsDisplaying
extension TermsViewController: TermsDisplaying {
    func displaySomething() { 
        // template
    }
}
