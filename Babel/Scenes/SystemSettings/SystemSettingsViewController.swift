import UIKit
import DesignKit
import StorageKit

import UserNotifications

protocol SystemSettingsDelegate: AnyObject {
    func didTapOnLogout()
}

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
        static let logout = Strings.Commons.logout.localized()
        static let logoutDescription = Strings.Commons.logoutDescription.localized()
        static let notifications = Strings.Notifications.notifications.localized()
        static let showNotifications = Strings.Notifications.showNotifications.localized()
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
    
    private let switchView = UISwitch(frame: .zero)
    
    weak var delegate: SystemSettingsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(appBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

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
        
        hasNotificationPermission { [weak self] granted in
            DispatchQueue.main.async {
                self?.switchView.setOn(granted, animated: true)
            }
        }
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
        
        switch indexPath.section {
        case 1:
            let clearCacheAction = UIAlertAction(title: Layout.Texts.clear, style: .destructive, handler: { [weak self] _ in
                self?.interactor.clearCache()
            })
            let actionSheet = UIAlertController(title: Layout.Texts.clearCache, message: Layout.Texts.clearCacheDescription, preferredStyle: .alert)
            actionSheet.addAction(clearCacheAction)
            actionSheet.addAction(UIAlertAction(title: Layout.Texts.cancel, style: .cancel, handler: nil))
            present(actionSheet, animated: true)
        case 2:
            let clearCacheAction = UIAlertAction(title: Layout.Texts.logout, style: .destructive, handler: { [weak self] _ in
                self?.navigationController?.popViewController(completion: { [weak self] _ in
                    self?.delegate?.didTapOnLogout()
                })
            })
            let actionSheet = UIAlertController(title: Layout.Texts.logout, message: Layout.Texts.logoutDescription, preferredStyle: .alert)
            actionSheet.addAction(clearCacheAction)
            actionSheet.addAction(UIAlertAction(title: Layout.Texts.cancel, style: .cancel, handler: nil))
            present(actionSheet, animated: true)
        default:
            break
        }
    }
}

extension SystemSettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? Layout.Texts.notifications : nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell: UITableViewCell = tableView.makeCell(indexPath: indexPath)
            switchView.tag = indexPath.row
            switchView.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
            cell.accessoryView = switchView
            var content = cell.defaultContentConfiguration()
            content.text = Layout.Texts.showNotifications
            cell.contentConfiguration = content
            
            return cell
        case 1:
            let button = Button()
            button.setTitle(Layout.Texts.clearCache, for: .normal)
            button.setTitleColor(Color.warning500.uiColor, for: .normal)
            let cell = tableView.makeCell(indexPath: indexPath)
            cell.fillWithSubview(subview: button, spacing: .init(top: 6, left: .zero, bottom: 6, right: .zero))
            return cell
        default:
            let button = Button()
            button.setTitle(Layout.Texts.logout, for: .normal)
            button.setTitleColor(Color.warning500.uiColor, for: .normal)
            let cell = UITableViewCell()
            cell.fillWithSubview(subview: button, spacing: .init(top: 6, left: .zero, bottom: 6, right: .zero))
            return cell
        }
    }
    
    @objc func switchChanged(_ sender: UISwitch) {
        if sender.isOn {
            StorageLocal.shared.saveBool(true, key: kENABLEDNOTIFICATIONS)
            
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.requestPushNotifications { granted in
                DispatchQueue.main.async {
                    sender.setOn(granted, animated: true)
                }
            }
        } else {
            StorageLocal.shared.saveBool(false, key: kENABLEDNOTIFICATIONS)
            UIApplication.shared.unregisterForRemoteNotifications()
        }
    }
    
    func hasNotificationPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            completion(settings.authorizationStatus == .authorized && StorageLocal.shared.getBool(key: kENABLEDNOTIFICATIONS))
        }
    }
    
    @objc func appBecomeActive() {
        hasNotificationPermission { [weak self] granted in
            DispatchQueue.main.async {
                self?.switchView.setOn(granted, animated: true)
            }
        }
    }
}
