import UIKit
import DesignKit

protocol GroupInfoHeaderDelegate: AnyObject {
    func didTapOnAvatar(_ image: UIImage)
}

final class GroupInfoHeaderCell: UITableViewCell, ViewConfiguration {
    private lazy var avatarImageView: ImageView = {
        let imageView = ImageView()
        imageView.layer.cornerRadius = 60
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var fullNameLabel: TextLabel = {
        let label = TextLabel()
        label.font = Font.lg.make(isBold: true)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var textsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [fullNameLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    weak var delegate: GroupInfoHeaderDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildViewHierarchy() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(textsStackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            avatarImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarImageView.heightAnchor.constraint(equalToConstant: 120),
            avatarImageView.widthAnchor.constraint(equalToConstant: 120)
        ])
        
        NSLayoutConstraint.activate([
            textsStackView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            textsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    func configureViews() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOnAvatar))
        avatarImageView.addGestureRecognizer(tap)
    }
}

extension GroupInfoHeaderCell {
    func render(_ dto: Group) {
        fullNameLabel.text = dto.name
        
        if !dto.avatarLink.isEmpty {
            avatarImageView.setImage(with: dto.avatarLink) { [weak self] image in
                self?.avatarImageView.image = image ?? Image.avatarPlaceholder.image
            }
        } else {
            avatarImageView.image = Image.avatarPlaceholder.image
        }
    }
    
    func update(_ dto: EditGroupDTO) {
        avatarImageView.image = dto.image
        fullNameLabel.text = dto.name
        layoutIfNeeded()
    }
}

@objc private extension GroupInfoHeaderCell {
    func didTapOnAvatar() {
        guard let image = avatarImageView.image else {
            return
        }
        delegate?.didTapOnAvatar(image)
    }
}
