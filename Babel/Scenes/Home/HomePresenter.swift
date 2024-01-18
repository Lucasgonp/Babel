protocol HomePresenterProtocol: AnyObject {
    func displayViewState(_ state: HomeViewState)
    func didNextStep(action: HomeAction)
}

final class HomePresenter {
    weak var viewController: HomeDisplaying?
    private let router: HomeRouterProtocol
    
    init(router: HomeRouterProtocol) {
        self.router = router
    }
}

extension HomePresenter: HomePresenterProtocol {
    func displayViewState(_ state: HomeViewState) {
        viewController?.displayViewState(state)
    }
    
    func didNextStep(action: HomeAction) {
        router.perform(action: action)
    }
}
