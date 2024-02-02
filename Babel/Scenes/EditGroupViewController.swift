import UIKit
import DesignKit
import GalleryKit

private extension EditGroupViewController.Layout {
    enum Texts {
        static let edit = Strings.Commons.edit.localized()
        static let groupNamePlaceholder = Strings.GroupInfo.groupNamePlaceholder.localized()
        static let done = Strings.Commons.done.localized()
        static let cancel = Strings.Commons.cancel.localized()
    }
}

final class EditGroupViewController: UIViewController {
    fileprivate enum Layout { }
    
    private let avatarImageView: ImageView = {
        let imageView = ImageView()
        imageView.layer.cornerRadius = 60
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var editAvatarButton: Button = {
        let button = Button()
        button.render(.tertiary(title: Layout.Texts.edit, titleColor: Color.blueNative))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var avatarStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [avatarImageView, editAvatarButton])
        stack.axis = .vertical
        stack.spacing = 6
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapEditAvatarButton))
        stack.addGestureRecognizer(tap)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var groupNameTextField: TextField = {
        let textField = TextField()
        textField.render(.simple(placeholder: Layout.Texts.groupNamePlaceholder, autocapitalizationType: .words, textLength: 35))
        textField.backgroundColor = Color.backgroundTertiary.uiColor
        textField.layer.cornerRadius = 8
        textField.clipsToBounds = true
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var doneButton: UIBarButtonItem = {
        let item = UIBarButtonItem(title: Layout.Texts.done, style: .done, target: self, action: #selector(didTapDoneButton))
        item.isEnabled = false
        return item
    }()
    
    private var galleryController: GalleryController?
    
    private let avatarLink: String
    
    var completion: ((EditGroupDTO) -> Void)?
    
    init(name: String?, avatarLink: String) {
        self.avatarLink = avatarLink
        super.init(nibName: nil, bundle: nil)
        self.groupNameTextField.text = name ?? String()
        self.avatarImageView.setImage(with: avatarLink) { [weak self] image in
            if let image {
                self?.avatarImageView.image = image
            } else {
                self?.avatarImageView.image = Image.avatarPlaceholder.image
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        groupNameTextField.becomeFirstResponder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
        groupNameTextField.becomeFirstResponder()
    }
}

extension EditGroupViewController: ViewConfiguration {
    func buildViewHierarchy() {
        view.addSubview(avatarStackView)
        view.addSubview(groupNameTextField)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.heightAnchor.constraint(equalToConstant: 120),
            avatarImageView.widthAnchor.constraint(equalToConstant: 120)
        ])
        
        NSLayoutConstraint.activate([
            avatarStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12)
        ])
        
        NSLayoutConstraint.activate([
            groupNameTextField.topAnchor.constraint(equalTo: editAvatarButton.bottomAnchor, constant: 12),
            groupNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            groupNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            groupNameTextField.heightAnchor.constraint(equalToConstant: 42)
        ])
    }
    
    func configureViews() {
        view.backgroundColor = Color.backgroundSecondary.uiColor
        
        navigationItem.setRightBarButton(doneButton, animated: true)
        
        let cancel = UIBarButtonItem(title: Layout.Texts.cancel, style: .plain, target: self, action: #selector(didTapCancelButton))
        navigationItem.setLeftBarButton(cancel, animated: true)
    }
}

@objc private extension EditGroupViewController {
    func didTapDoneButton() {
        view.endEditing(true)
        dismiss(animated: true) { [weak self] in
            guard let self else { return }
            let dto = EditGroupDTO(name: self.groupNameTextField.text, avatar: avatarImageView.image ?? Image.avatarPlaceholder.image, avatarLink: avatarLink)
            self.completion?(dto)
        }
    }
    
    func didTapCancelButton() {
        view.endEditing(true)
        dismiss(animated: true)
    }
}

extension EditGroupViewController: TextFieldDelegate {
    func textFieldDidChange(_ textField: TextFieldInput) {
        doneButton.isEnabled = !groupNameTextField.text.isEmpty
    }
}

@objc private extension EditGroupViewController {
    func didTapEditAvatarButton() {
        galleryController = GalleryController()
        galleryController?.configuration = .avatarPhoto
        galleryController?.showMediaPicker(from: navigationController) { [weak self] mediaItems in
            self?.galleryController = nil
            if let singlePhoto = mediaItems.singlePhoto {
                self?.avatarImageView.image = singlePhoto.image
                self?.doneButton.isEnabled = true
            }
        }
    }
}
