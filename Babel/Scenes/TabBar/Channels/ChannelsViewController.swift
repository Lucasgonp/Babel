import UIKit
import DesignKit

protocol ChannelsDisplaying: AnyObject {
    func displaySomething()
}

private extension ChannelsViewController.Layout {
    // example
    enum Size {
        static let imageHeight: CGFloat = 90.0
    }
}

final class ChannelsViewController: ViewController<ChannelsInteracting, UIView> {
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
        view.backgroundColor = Color.backgroundPrimary.uiColor
    }
}

// MARK: - ChannelsDisplaying
extension ChannelsViewController: ChannelsDisplaying {
    func displaySomething() { 
        // template
    }
}
