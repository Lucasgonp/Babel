import UIKit
import DesignKit

protocol TermsDisplaying: AnyObject {
    func displaySomething()
}

private extension TermsViewController.Layout {
    enum Texts {
        static let title = Strings.Settings.TermsAndConditions.title.localized()
    }
}

final class TermsViewController: ViewController<TermsInteractorProtocol, UIView> {
    fileprivate enum Layout { }
    
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
        title = Layout.Texts.title
        view.backgroundColor = Color.grayscale050.uiColor
    }
}

// MARK: - TermsDisplaying
extension TermsViewController: TermsDisplaying {
    func displaySomething() { 
        // template
    }
}
