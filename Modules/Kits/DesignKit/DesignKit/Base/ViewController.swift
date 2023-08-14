import UIKit

public protocol ViewConfiguration: AnyObject {
    func buildViewHierarchy()
    func setupConstraints()
    func configureViews()
    func configureStyles()
    func buildLayout()
}

public extension ViewConfiguration {
    func buildLayout() {
        buildViewHierarchy()
        setupConstraints()
        configureViews()
        configureStyles()
    }

    func configureViews() { }

    func configureStyles() { }
}

open class ViewController<Interactor, V: UIView>: UIViewController, ViewConfiguration {
    private lazy var spinnerView: SpinnerView = {
        let view = SpinnerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public let interactor: Interactor
    public var rootView = V()

    public init(interactor: Interactor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
    }

    override open func loadView() {
        view = rootView
    }

    open func buildViewHierarchy() { }

    open func setupConstraints() { }

    open func configureViews() { }
}

public extension ViewController where Interactor == Void {
    convenience init(_ interactor: Interactor = ()) {
        self.init(interactor: interactor)
    }
}

extension ViewController {
    public func showLoading() {
        view.addSubview(spinnerView)
        
        NSLayoutConstraint.activate([
            spinnerView.topAnchor.constraint(equalTo: view.topAnchor),
            spinnerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            spinnerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            spinnerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    public func hideLoading() {
        spinnerView.removeFromSuperview()
    }
}
