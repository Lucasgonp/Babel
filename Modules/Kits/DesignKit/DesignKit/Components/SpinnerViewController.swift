import UIKit

final class SpinnerView: UIView {
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        spinner.color = .gray
        return spinner
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SpinnerView: ViewConfiguration {
    func buildViewHierarchy() {
        addSubview(spinner)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            spinner.heightAnchor.constraint(equalToConstant: 80),
            spinner.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    func configureViews() {
        backgroundColor = Color.backgroundPrimary.uiColor
    }
}

extension SpinnerView {
    func showLoading(style: UIActivityIndicatorView.Style) {
        spinner.style = style
        spinner.isHidden = false
        reloadInputViews()
        
        spinner.startAnimating()
    }
    
    func hideLoading() {
        spinner.stopAnimating()
    }
}
