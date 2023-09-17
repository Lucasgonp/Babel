import UIKit
import DesignKit

protocol RecentChatsDisplaying: AnyObject {
    func displaySomething()
}

private extension RecentChatsViewController.Layout {
    // example
    enum Size {
        static let imageHeight: CGFloat = 90.0
    }
}

final class RecentChatsViewController: ViewController<RecentChatsInteracting, UIView> {
    fileprivate enum Layout { 
        // template
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(cellType: UserCell.self)
//        tableView.delegate = self
//        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        interactor.loadSomething()
    }

    override func buildViewHierarchy() { 
        view.fillWithSubview(subview: tableView)
    }
    
    override func setupConstraints() { 
        // template
    }

    override func configureViews() { 
        // template
    }
}

// MARK: - RecentChatsDisplaying
extension RecentChatsViewController: RecentChatsDisplaying {
    func displaySomething() { 
        // template
    }
}
