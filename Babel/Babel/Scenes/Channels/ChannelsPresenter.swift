protocol ChannelsPresenting: AnyObject {
    func displaySomething()
    func didNextStep(action: ChannelsAction)
}

final class ChannelsPresenter {
    private let router: ChannelsRouting
    weak var viewController: ChannelsDisplaying?

    init(router: ChannelsRouting) {
        self.router = router
    }
}

// MARK: - ChannelsPresenting
extension ChannelsPresenter: ChannelsPresenting {
    func displaySomething() {
        viewController?.displaySomething()
    }
    
    func didNextStep(action: ChannelsAction) {
        router.perform(action: action)
    }
}
