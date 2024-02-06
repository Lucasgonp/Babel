import UIKit
import DesignKit

protocol TermsAlertViewDelegate: AnyObject {
    func didTapPrimaryButton()
    func didTapSecondaryButton()
}

private extension TermsAlertView.Layout {
    enum Texts {
        static let title = Strings.TermsAndConditions.title.localized()
        static let description = Strings.TermsAndConditions.description.localized()
        static let termsButton = Strings.TermsAndConditions.termsButton.localized()
        static let acceptButton = Strings.TermsAndConditions.iAcceptButton.localized()
    }
}

final class TermsAlertView: UIView {
    fileprivate enum Layout { }
    
    private let titleLabel: TextLabel = {
        let label = TextLabel()
        label.text = Layout.Texts.title
        label.font = Font.lg.make(isBold: true)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: TextLabel = {
        let label = TextLabel()
        label.numberOfLines = .zero
        label.text = Layout.Texts.description
        label.textAlignment = .center
        label.font = Font.md.uiFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var termsButton: Button = {
        let button = Button()
        button.render(.secondary(title: Layout.Texts.termsButton))
        button.addTarget(self, action: #selector(didTapOnTerms), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var confirmButton: Button = {
        let button = Button()
        button.render(.primary(title: Layout.Texts.acceptButton))
        button.addTarget(self, action: #selector(didTapOnAccept), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, termsButton, confirmButton])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    weak var delegate: TermsAlertViewDelegate?
    
    init() {
        super.init(frame: .zero)
        self.buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showAlert(from viewController: UIViewController) {
        viewController.view.addSubview(self)
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor, constant: 16),
            trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor, constant: -16),
            centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor),
            heightAnchor.constraint(greaterThanOrEqualToConstant: 160)
        ])
    }
    
    func hideAlert() {
        removeFromSuperview()
    }
}

extension TermsAlertView: ViewConfiguration {
    func buildViewHierarchy() {
        fillWithSubview(subview: stackView, spacing: .init(top: 22, left: 30, bottom: 22, right: 30))
    }
    
    func configureViews() {
        backgroundColor = Color.backgroundTertiary.uiColor
        layer.masksToBounds = true
        layer.cornerRadius = 12
        
        stackView.setCustomSpacing(32, after: descriptionLabel)
        stackView.setCustomSpacing(8, after: termsButton)
    }
}

@objc private extension TermsAlertView {
    func didTapOnTerms() {
        delegate?.didTapPrimaryButton()
    }
    
    func didTapOnAccept() {
        delegate?.didTapSecondaryButton()
    }
}
