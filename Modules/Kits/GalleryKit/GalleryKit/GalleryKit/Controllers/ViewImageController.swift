import UIKit
import DesignKit

protocol ImageFullscreenProtocol: AnyObject {
    func dragImageView()
    func handleDragEnded()
}

private extension PreviewAvatarViewController.Layout {
    enum ImageView {
        static let size = CGSize(width: 120, height: 120)
        static let cornerRadius: CGFloat = 120 / 2
        static let centerY: CGFloat = 203
    }
}

public final class PreviewAvatarViewController: UIViewController {
    fileprivate enum Layout { }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = Layout.ImageView.cornerRadius
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(dragGestureFinish)
        imageView.frame.size = Layout.ImageView.size
        return imageView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var dragGestureFinish: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(dragged))
        return gesture
    }()
    
    private var centerY = Layout.ImageView.centerY
    
    public init(image: UIImage) {
        super.init(nibName: nil, bundle: nil)
        imageView.image = image
        view.backgroundColor = Color.grayscale600.uiColor.withAlphaComponent(opacity: 0.8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
    }
}

private extension PreviewAvatarViewController {
    func buildLayout() {
        buildViewHierarchy()
        configureViews()
        setupConstraints()
    }
    
    func buildViewHierarchy() {
        view.addSubview(imageView)
    }
    
    func setupConstraints() {
        imageView.center.x = view.center.x
        imageView.center.y = centerY
    }
    
    func configureViews() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        view.addGestureRecognizer(tap)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [weak self] in
            self?.animate()
        }
    }
    
    func animate() {
        UIView.animate(withDuration: 0.2) { [unowned self] in
            self.imageView.layer.cornerRadius = 0
            self.imageView.frame = CGRect(
                x: self.view.frame.origin.x,
                y: self.view.center.y - 196,
                width: self.view.frame.width,
                height: self.view.frame.width
            )
        }
    }
    
    func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt(xDist * xDist + yDist * yDist))
    }
}

extension PreviewAvatarViewController: ImageFullscreenProtocol {
    func dragImageView() {
        view.bringSubviewToFront(imageView)
        let translation = dragGestureFinish.translation(in: view)
        imageView.center = CGPoint(x: imageView.center.x + translation.x, y: imageView.center.y + translation.y)
        dragGestureFinish.setTranslation(CGPoint.zero, in: view)
    }
    
    func handleDragEnded() {
        let centerX = abs(imageView.center.x)
        let centerY = abs(imageView.center.y)
        let point = CGPoint(x: centerX, y: centerY)
        
        if distance(point, view.center) > 350 {
            dismissView()
        } else {
            UIView.animate(withDuration: 0.2) { [unowned self] in
                self.imageView.center = self.view.center
            }
        }
    }
}

@objc private extension PreviewAvatarViewController {
    func dragged() {
        switch dragGestureFinish.state {
        case .ended:
            handleDragEnded()
        default:
            dragImageView()
        }
    }
    
    func dismissView() {
        UIView.animate(withDuration: 0.2) { [unowned self] in
            self.view.backgroundColor = .white.withAlphaComponent(0)
            self.imageView.layer.cornerRadius = Layout.ImageView.cornerRadius
            self.imageView.frame.size = Layout.ImageView.size
            self.imageView.center.x = self.view.center.x
            self.imageView.center.y = self.centerY
        } completion: { finish in
            self.dismiss(animated: true)
        }
    }
}
