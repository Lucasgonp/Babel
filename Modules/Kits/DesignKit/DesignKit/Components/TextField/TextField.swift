import UIKit
import CoreKit

public class TextField: UIView {
    public var validations = [Validation]()
    
    private var _state: State = .none {
        didSet {
            setupFeedbackView()
        }
    }
    
    weak var delegate: TextFieldDelegate?
    
    private lazy var hintView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var hintLabel: Text = {
        let label = Text()
        label.font = Font.sm.uiFont
        label.textColor = Color.grayscale600.uiColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    private lazy var textFieldInput: TextFieldInput = {
        let textField = TextFieldInput()
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.addTarget(self, action: #selector(textFieldDidBeginEditing), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEnd)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.grayscale400.uiColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var componentsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [inputsStackView, lineView, feedbackView])
        stack.axis = .vertical
        stack.spacing = 1
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var inputsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [hintView, textFieldInput])
        stack.axis = .vertical
        stack.spacing = 1
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var feedbackStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [feedbackIcon, feedbackText])
        stack.axis = .horizontal
        stack.spacing = 2
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var feedbackIcon: UIImageView = {
        let imageView = ImageView.icon(.feedbackDanger)
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var feedbackText: Text = {
        let text = Text()
        text.font = Font.xs.uiFont
        text.textColor = Color.warning500.uiColor
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private lazy var feedbackView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func render(_ theme: TextFieldTheme) {
        textFieldInput.render(theme)
        hintLabel.text = theme.dto.hint ??  theme.dto.placeholder
        
        if let border = theme.border {
            inputsStackView.layer.cornerRadius = border.cornerRadius
            inputsStackView.layer.borderWidth = border.borderWidth
            inputsStackView.layer.borderColor = border.borderColor.uiColor.cgColor
            inputsStackView.clipsToBounds = true
        }
    }
    
    public func validate() -> Bool {
        let message = validations
            .compactMap { $0.run(textFieldInput.text ?? "") }
            .compactMap { $0.message }
            .joined(separator: ", ")
        
        if !message.isEmpty {
            _state = .error(message)
            return false
        } else {
            self._state = .success
            return true
        }
    }
    
    func setupFeedbackView() {
        switch _state {
        case .none, .success:
            feedbackIcon.isHidden = true
            feedbackText.isHidden = true
            lineView.backgroundColor = Color.grayscale400.uiColor
        case .error(let message):
            feedbackIcon.isHidden = false
            feedbackText.isHidden = false
            lineView.backgroundColor = Color.warning500.uiColor
            feedbackText.text = message
        }
    }
}

extension TextField: ViewConfiguration {
    public func buildViewHierarchy() {
        addSubview(componentsStackView)
        hintView.addSubview(hintLabel)
        feedbackView.addSubview(feedbackStackView)
    }
    
    public func setupConstraints() {
        NSLayoutConstraint.activate([
            componentsStackView.topAnchor.constraint(equalTo: topAnchor),
            componentsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            componentsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            componentsStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            hintLabel.topAnchor.constraint(equalTo: hintView.topAnchor),
            hintLabel.leadingAnchor.constraint(equalTo: hintView.leadingAnchor, constant: 6),
            hintLabel.trailingAnchor.constraint(equalTo: hintView.trailingAnchor, constant: -6),
            hintLabel.bottomAnchor.constraint(equalTo: hintView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            hintView.heightAnchor.constraint(equalToConstant: 12)
        ])
        
        NSLayoutConstraint.activate([
            feedbackView.heightAnchor.constraint(equalToConstant: 12)
        ])
        
        NSLayoutConstraint.activate([
            textFieldInput.heightAnchor.constraint(equalToConstant: 34)
        ])
        
        NSLayoutConstraint.activate([
            lineView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}

@objc private extension TextField {
    func textFieldDidChange() {
        _state = .none
        if let text = textFieldInput.text, !text.isEmpty {
            hintLabel.isHidden = false
        } else {
            hintLabel.isHidden = true
        }
        
        delegate?.textFieldDidChange(textFieldInput)
    }
    
    func textFieldDidBeginEditing() {
        delegate?.textFieldDidBeginEditing(textFieldInput)
    }
    
    func textFieldDidEndEditing() {
        delegate?.textFieldDidEndEditing(textFieldInput)
    }
}
