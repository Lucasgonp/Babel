import UIKit
import DesignKit
import Authenticator

enum HomeViewState {
    case loading(isLoading: Bool)
    case success(message: String)
    case error(message: String)
}

protocol HomeDisplaying: AnyObject {
    func displayViewState(_ state: HomeViewState)
}

protocol HomeViewDelegate: AnyObject {
    func reloadData()
}

private extension HomeViewController.Layout {
    enum Size {
        static let imageHeight: CGFloat = 90.0
    }
}

final class HomeViewController: ViewController<HomeInteracting, UIView> {
    fileprivate enum Layout { }
    typealias Localizable = Strings.Home
    
    private lazy var logoutBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(title: Localizable.Navigation.logout, style: .plain, target: self, action: #selector(logoutAction))
        return barButton
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.checkAuthentication()
    }

    override func buildViewHierarchy() {
        // template
    }

    override func setupConstraints() {
        // template
    }

    override func configureViews() {
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = logoutBarButton
    }
}

extension HomeViewController: HomeDisplaying {
    func displayViewState(_ state: HomeViewState) {
        switch state {
        case .loading(let isLoading):
            setupLoading(isLoading: isLoading)
        case .success(let message):
            print(message)
        case .error(let message):
            print(message)
        }
    }
}

extension HomeViewController: HomeViewDelegate {
    func reloadData() {
        interactor.checkAuthentication()
    }
}

@objc private extension HomeViewController {
    func logoutAction() {
        interactor.performLogout()
    }
}

private extension HomeViewController {
    func setupLoading(isLoading: Bool) {
        if isLoading {
            showLoading()
        } else {
            hideLoading()
        }
    }
}
