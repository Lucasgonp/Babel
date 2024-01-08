protocol HomePresenting: AnyObject {
    func displayViewState(_ state: HomeViewState)
    func didNextStep(action: HomeAction)
}

final class HomePresenter {
    weak var viewController: HomeDisplaying?
    private let router: HomeRouting
    
    init(router: HomeRouting) {
        self.router = router
    }
}

extension HomePresenter: HomePresenting {
    func displayViewState(_ state: HomeViewState) {
        viewController?.displayViewState(state)
    }
    
    func didNextStep(action: HomeAction) {
        router.perform(action: action)
    }
}
