import UIKit
import DesignKit

protocol SystemSettingsDisplaying: AnyObject {
    func displaySomething()
}

private extension SystemSettingsViewController.Layout {
    enum Texts {
        static let title = Strings.SystemSettings.title.localized()
        static let clear = Strings.SystemSettings.clear.localized()
        static let clearCache = Strings.SystemSettings.clearCache.localized()
        static let clearCacheDescription = Strings.SystemSettings.clearCacheDescription.localized()
        static let cancel = Strings.Commons.cancel.localized()
    }
}

final class SystemSettingsViewController: ViewController<SystemSettingsInteractorProtocol, UIView> {
    fileprivate enum Layout { }
    
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
        title = Layout.Texts.title
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
        
        let clearCacheAction = UIAlertAction(title: Layout.Texts.clear, style: .destructive, handler: { [weak self] _ in
            self?.interactor.clearCache()
        })
        
        let actionSheet = UIAlertController(title: Layout.Texts.clearCache, message: Layout.Texts.clearCacheDescription, preferredStyle: .alert)
        actionSheet.addAction(clearCacheAction)
        actionSheet.addAction(UIAlertAction(title: Layout.Texts.cancel, style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    }
}

extension SystemSettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let button = Button()
        button.setTitle(Layout.Texts.clearCache, for: .normal)
        button.setTitleColor(Color.warning500.uiColor, for: .normal)
        let cell = tableView.makeCell(indexPath: indexPath)
        cell.fillWithSubview(subview: button, spacing: .init(top: 6, left: .zero, bottom: 6, right: .zero))
        return cell
    }
}
