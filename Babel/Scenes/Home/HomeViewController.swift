import UIKit
import DesignKit
import Authenticator

enum HomeViewState {
    case loading(isLoading: Bool)
    case success(user: User)
    case error(message: String)
}

protocol HomeDisplaying: AnyObject {
    func displayViewState(_ state: HomeViewState)
}

protocol HomeViewDelegate: AnyObject {
    func logout()
    func reloadData()
}

private extension HomeViewController.Layout {
    enum Size {
        static let imageHeight: CGFloat = 90.0
    }
}

final class HomeViewController: TabBarViewController<HomeInteracting> {
    fileprivate enum Layout { }

    override func viewDidLoad() {
        super.viewDidLoad()
        showLoading()
        interactor.checkAuthentication()
    }

    override func configureViews() {
        view.backgroundColor = Color.backgroundPrimary.uiColor
        tabBar.isTranslucent = true
        tabBar.isHidden = true
    }
}

extension HomeViewController: HomeDisplaying {
    func displayViewState(_ state: HomeViewState) {
        switch state {
        case .loading(let isLoading):
            setupLoading(isLoading: isLoading)
        case .success(let user):
            configureTabBar(with: user)
        case .error(let message):
            print(message)
        }
    }
}

extension HomeViewController: HomeViewDelegate {
    func logout() {
        var viewModel = AlertViewModel(
            title: "Logout",
            message: "Do you want to logout?",
            firstButton: .init(title: "Logout", style: .destructive),
            secondButton: .init(title: "Back", style: .default)
        )
        viewModel.firstButtonAction = { [weak self] _ in
            self?.interactor.performLogout()
        }
        showMessageAlert(viewModel: viewModel)
    }
    
    func reloadData() {
        interactor.checkAuthentication()
    }
}

private extension HomeViewController {
    func configureTabBar(with user: User) {
        let tabBars = HomeTabBarFactory.makeTabs(delegate: self, for: user)
        setViewControllers(tabBars.compactMap({ $0.navigation }), animated: false)
        tabBar.items?.enumerated().forEach({ index, item in
            item.image = tabBars[index].icon
            
            if index == (tabBars.count - 1) {
                tabBar.isHidden = false
                hideLoading()
            }
        })
    }
    
    func setupLoading(isLoading: Bool) {
        if isLoading {
            showLoading()
        } else {
            hideLoading()
        }
    }
}
