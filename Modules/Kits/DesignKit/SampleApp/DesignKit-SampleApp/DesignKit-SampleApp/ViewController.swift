import UIKit
import DesignKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

private extension ViewController {
    func setupViews() {
        let custom = DesignView(theme: .light)
        custom.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(custom)
        
        NSLayoutConstraint.activate([
            custom.heightAnchor.constraint(equalToConstant: 200),
            custom.widthAnchor.constraint(equalToConstant: 200),
            custom.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            custom.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
