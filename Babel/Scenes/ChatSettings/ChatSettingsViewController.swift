import UIKit
import DesignKit
import StorageKit

private extension ChatSettingsViewController.Layout {
    enum Texts {
        static let title = Strings.ChatSettings.title.localized()
        static let changeChatWallpaper = Strings.ChatSettings.changeWallpaper.localized()
    }
}

final class ChatSettingsViewController: UIViewController {
    fileprivate enum Layout { }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(cellType: UITableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let router: ChatSettingsRouterProtocol
    
    init(router: ChatSettingsRouterProtocol) {
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }
}

extension ChatSettingsViewController: ViewConfiguration {
    func buildViewHierarchy() {
        view.fillWithSubview(subview: tableView, navigationSafeArea: true)
    }

    func configureViews() {
        title = Layout.Texts.title
        view.backgroundColor = Color.backgroundPrimary.uiColor
        
        let backButton = UIBarButtonItem(title: String(), style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
}

extension ChatSettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        router.changeWallpaper()
    }
}

extension ChatSettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.makeCell(indexPath: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = Layout.Texts.changeChatWallpaper
        cell.contentConfiguration = content
        return cell
    }
}
