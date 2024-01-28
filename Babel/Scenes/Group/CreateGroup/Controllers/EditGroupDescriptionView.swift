import UIKit
import DesignKit

private extension EditGroupDescViewController.Layout {
    enum Texts {
        static let descriptionInfo = Strings.GroupInfo.descriptionInfo.localized()
        static let done = Strings.Commons.done.localized()
        static let cancel = Strings.Commons.cancel.localized()
    }
}

final class EditGroupDescViewController: UIViewController {
    fileprivate enum Layout { }
    
    private let descriptionLabel: TextLabel = {
        let label = TextLabel(font: Font.xs.make())
        label.text = Layout.Texts.descriptionInfo
        label.textColor = Color.grayscale700.uiColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.delegate = self
        textView.backgroundColor = Color.backgroundTertiary.uiColor
        textView.layer.cornerRadius = 8
        textView.clipsToBounds = true
        textView.font = Font.md.uiFont
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [textView, descriptionLabel])
        stack.axis = .vertical
        stack.spacing = 3
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var doneButton: UIBarButtonItem = {
        let item = UIBarButtonItem(title: Layout.Texts.done, style: .done, target: self, action: #selector(didTapDoneButton))
        item.isEnabled = false
        return item
    }()
    
    var completion: ((String) -> Void)?
    
    init(description: String) {
        super.init(nibName: nil, bundle: nil)
        self.textView.text = description
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
        textView.becomeFirstResponder()
    }
}

extension EditGroupDescViewController: ViewConfiguration {
    func buildViewHierarchy() {
        view.addSubview(stackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22)
        ])
        
        NSLayoutConstraint.activate([
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 220)
        ])
    }
    
    func configureViews() {
        view.backgroundColor = Color.backgroundSecondary.uiColor
        
        navigationItem.setRightBarButton(doneButton, animated: true)
        
        let cancel = UIBarButtonItem(title: Layout.Texts.cancel, style: .plain, target: self, action: #selector(didTapCancelButton))
        navigationItem.setLeftBarButton(cancel, animated: true)
    }
}

@objc private extension EditGroupDescViewController {
    func didTapDoneButton() {
        view.endEditing(true)
        dismiss(animated: true) { [unowned self] in
            self.completion?(textView.text)
        }
    }
    
    func didTapCancelButton() {
        view.endEditing(true)
        dismiss(animated: true)
    }
}

extension EditGroupDescViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        doneButton.isEnabled = !textView.text.isEmpty
    }
}
