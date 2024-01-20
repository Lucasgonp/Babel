import UIKit
import DesignKit

protocol SystemSettingsDisplaying: AnyObject {
    func displaySomething()
}

final class SystemSettingsViewController: ViewController<SystemSettingsInteractorProtocol, UIView> {
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(cellType: UITableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }

    override func buildViewHierarchy() {
        view.fillWithSubview(subview: tableView, navigationSafeArea: true)
    }
    
    override func setupConstraints() { }

    override func configureViews() {
        title = "System settings"
        view.backgroundColor = Color.backgroundPrimary.uiColor
    }
}

extension SystemSettingsViewController: SystemSettingsDisplaying {
    func displaySomething() { 
        // template
    }
}

extension SystemSettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let clearCacheAction = UIAlertAction(title: "Clear", style: .destructive, handler: { [weak self] _ in
            self?.interactor.clearCache()
        })
        
        let actionSheet = UIAlertController(title: "Clear cache", message: "Do you want to clear cache?", preferredStyle: .alert)
        actionSheet.addAction(clearCacheAction)
        actionSheet.addAction(UIAlertAction(title: Strings.Commons.cancel, style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    }
}

extension SystemSettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let button = Button()
        button.setTitle("Clear cache", for: .normal)
        button.setTitleColor(Color.warning500.uiColor, for: .normal)
        let cell = tableView.makeCell(indexPath: indexPath)
        cell.fillWithSubview(subview: button, spacing: .init(top: 6, left: .zero, bottom: 6, right: .zero))
        return cell
    }
}
