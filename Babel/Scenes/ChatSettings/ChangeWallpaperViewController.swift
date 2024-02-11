import UIKit
import DesignKit
import StorageKit

private extension ChangeWallpaperViewController.Layout {
    enum Texts {
        static let title = Strings.ChatSettings.changeWallpaper.localized()
        static let cancel = Strings.Commons.cancel.localized()
        static let resetWallpaper = Strings.ChatWallpaper.resetWallpaper.localized()
        static let actionSheetTitle = Strings.ChatWallpaper.ActionSheet.title.localized()
        static let actionSheetButton = Strings.ChatWallpaper.ActionSheet.button.localized()
        static let actionSheetDescription = Strings.ChatWallpaper.ActionSheet.description.localized()
    }
}

final class ChangeWallpaperViewController: UIViewController {
    fileprivate enum Layout { }
    
    private lazy var resetButton: UIButton = {
        let button = Button()
        button.render(.primary(title: Layout.Texts.resetWallpaper))
        button.addTarget(self, action: #selector(resetButtonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 8
        flowLayout.minimumLineSpacing = 16
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(cellType: UICollectionViewCell.self)
        collectionView.register(cellType: UICollectionReusableView.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private let allWallpapers = [
        Image.chatBackgroundImage1,
        Image.chatBackgroundImage2,
        Image.chatBackgroundImage3,
        Image.chatBackgroundImage4,
        Image.chatBackgroundImage5,
        Image.chatBackgroundImage6,
        Image.chatBackgroundImage7,
        Image.chatBackgroundImage8,
        Image.chatBackgroundImage9,
        Image.chatBackgroundImage10,
        Image.chatBackgroundImage11,
        Image.chatBackgroundImage12,
        Image.chatBackgroundImage13,
        Image.chatBackgroundImage14,
        Image.chatBackgroundImage15
    ]
    
    private var selectedWallpaperName: String? {
        StorageLocal.shared.getString(key: kCHATWALLPAPER)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }
}

extension ChangeWallpaperViewController: ViewConfiguration {
    func buildViewHierarchy() {
        view.fillWithSubview(subview: collectionView, considerSafeArea: true)
        
        func configureViews() {
            title = Layout.Texts.title
            view.backgroundColor = Color.backgroundPrimary.uiColor
        }
    }
}

extension ChangeWallpaperViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        showAlertView { [weak self] in
            guard let self else { return }
            let wallpaper = self.allWallpapers[indexPath.row]
            StorageLocal.shared.saveString(wallpaper.name, key: kCHATWALLPAPER)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func showAlertView(completion: @escaping () -> Void) {
        let changeWallpaperAction = UIAlertAction(title: Layout.Texts.actionSheetButton, style: .default, handler: { _ in
            completion()
        })
        let actionSheet = UIAlertController(title: Layout.Texts.actionSheetTitle, message: Layout.Texts.actionSheetDescription, preferredStyle: .alert)
        actionSheet.addAction(changeWallpaperAction)
        actionSheet.addAction(UIAlertAction(title: Layout.Texts.cancel, style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    }
}

extension ChangeWallpaperViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allWallpapers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.makeCell(indexPath: indexPath)
        let wallpaper = allWallpapers[indexPath.row]
        let imageView = UIImageView(image: wallpaper.image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        cell.contentView.fillWithSubview(subview: imageView, spacing: .init(top: 4, left: 4, bottom: 4, right: 4))
        cell.contentView.clipsToBounds = true
        
        if selectedWallpaperName == wallpaper.name {
            cell.contentView.layer.borderWidth = 4
            cell.contentView.layer.borderColor = Color.primary800.cgColor
            cell.contentView.layer.cornerRadius = 4
        } else {
            cell.contentView.layer.borderWidth = 0
            cell.contentView.layer.borderColor = Color.clear.cgColor
            cell.contentView.layer.cornerRadius = 0
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.makeView(kind: kind, indexPath: indexPath)
        headerView.fillWithSubview(subview: resetButton, spacing: .init(top: 6, left: 16, bottom: 16, right: 16))
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 62)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }
}

extension ChangeWallpaperViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return .zero
        }
        
        let noOfCellsInRow = 2
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        return CGSize(width: size, height: 321)
    }
}

@objc private extension ChangeWallpaperViewController {
    func resetButtonAction() {
        showAlertView { [weak self] in
            StorageLocal.shared.removeStorage(key: kCHATWALLPAPER)
            self?.collectionView.reloadData()
        }
    }
}
