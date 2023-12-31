import UIKit
import DesignKit

protocol BarButtonViewDelegate: AnyObject {
    func didTapOnView()
}

final class BarButtonView: UIView {
    private lazy var titleLabel: TextLabel = {
        let label = TextLabel()
        label.text = "Test"
        label.textAlignment = .center
        label.font = Font.lg.make(isBold: true)
        label.adjustsFontSizeToFitWidth = true
        label.backgroundColor = .red
        return label
    }()
    
    private lazy var descriptionLabel: TextLabel = {
        let label = TextLabel()
        label.text = "Test"
        label.textAlignment = .center
        label.font = Font.sm.uiFont
        label.adjustsFontSizeToFitWidth = true
        label.backgroundColor = .blue
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel])
        stack.axis = .vertical
        stack.spacing = 2
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = .yellow
        return stack
    }()
    
    weak var delegate: BarButtonViewDelegate?
    
    func setup(title: String, description: String?) {
        titleLabel.text = title
        
        if let description {
            descriptionLabel.text = description
            stackView.addArrangedSubview(descriptionLabel)
        } else {
            stackView.removeArrangedSubview(descriptionLabel)
        }
        
        layoutSubviews()
    }
}

extension BarButtonView: ViewConfiguration {
    func buildViewHierarchy() {
        addSubview(stackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            stackView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
}
