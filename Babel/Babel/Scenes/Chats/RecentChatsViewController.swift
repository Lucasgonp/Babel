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
        tableView.register(cellType: RecentChatCell.self)
        tableView.delegate = self
        tableView.dataSource = self
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

extension RecentChatsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension RecentChatsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RecentChatCell = tableView.makeCell(indexPath: indexPath)
        cell.render()
        return cell
    }
}
