import UIKit
import DesignKit

protocol EditProfileHeaderDelegate: AnyObject {
    func didTapOnEditAvatar()
    func didTapOnAvatar(image: UIImage)
}

private extension EditProfileHeaderCell.Layout {
    enum Texts {
        static let edit = Strings.Commons.edit.localized()
    }
}

final class EditProfileHeaderCell: UITableViewCell, ViewConfiguration {
    fileprivate enum Layout { }

    private lazy var avatar: ImageView = {
        let imageView = ImageView()
        imageView.layer.cornerRadius = 60
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var editAvatarButton: Button = {
        let button = Button()
        button.render(.tertiary(title: Layout.Texts.edit, titleColor: Color.blueNative))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapEditAvatarButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var avatarStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [avatar, editAvatarButton])
        stack.axis = .vertical
        stack.spacing = .zero
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    weak var delegate: EditProfileHeaderDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildViewHierarchy() {
        contentView.addSubview(avatarStackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            avatar.heightAnchor.constraint(equalToConstant: 120),
            avatar.widthAnchor.constraint(equalToConstant: 120)
        ])
        
        NSLayoutConstraint.activate([
            avatarStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            avatarStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            avatarStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    func configureViews() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOnAvatar))
        avatar.isUserInteractionEnabled = true
        avatar.addGestureRecognizer(tap)
    }
}

extension EditProfileHeaderCell {
    func render(_ dto: User) {
        avatar.setImage(with: dto.avatarLink) { [weak self] image in
            self?.avatar.image = image ?? Image.avatarPlaceholder.image
        }
    }
    
    func update(_ image: UIImage) {
        avatar.image = image
    }
}

@objc private extension EditProfileHeaderCell {
    func didTapEditAvatarButton() {
        delegate?.didTapOnEditAvatar()
    }
    
    func didTapOnAvatar() {
        guard let image = avatar.image else {
            return
        }
        delegate?.didTapOnAvatar(image: image)
    }
}
