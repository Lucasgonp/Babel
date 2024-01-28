import UIKit
import DesignKit

protocol CreateGroupHeaderCellDelegate: AnyObject {
    func didTapOnEditAvatar()
    func didTapOnAvatar(image: UIImage)
}

final class CreateGroupHeaderCell: UITableViewCell, ViewConfiguration {
    private lazy var avatar: ImageView = {
        let imageView = ImageView(image: Image.avatarPlaceholder.image)
        imageView.layer.cornerRadius = 60
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var editAvatarButton: Button = {
        let button = Button()
        button.render(.tertiary(title: "Edit", titleColor: Color.blueNative))
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

extension CreateGroupHeaderCell {
    func render(_ avatarLink: String) {
        avatar.setImage(with: avatarLink, placeholderImage: Image.avatarPlaceholder.image) { [weak self] image in
            if let image {
                self?.avatar.image = image
            } else {
                self?.avatar.image = Image.avatarPlaceholder.image
            }
        }
    }
    
    func update(_ image: UIImage) {
        avatar.image = image
    }
}

@objc private extension CreateGroupHeaderCell {
    func didTapEditAvatarButton() {
        delegate?.didTapOnEditAvatar()
    }
    
    func didTapOnAvatar() {
        if let image = avatar.image {
            delegate?.didTapOnAvatar(image: image)
        }
    }
}
