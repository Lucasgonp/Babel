import UIKit
import DesignKit

protocol OpenAIDisplaying: AnyObject {
    func displaySomething()
}

final class OpenAIViewController: ViewController<OpenAIInteractorProtocol, UIView> {
    typealias Localizable = Strings.OpenAI
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(cellType: OpenAICell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let bots = [
        OpenAIDTO(name: Localizable.ChatBot.title, bio: Localizable.ChatBot.description, avatar: Icon.marvin.image.withRenderingMode(.alwaysOriginal)),
        OpenAIDTO(name: Localizable.ImageGenerator.title, bio: Localizable.ImageGenerator.description, avatar: UIImage(systemName: "theatermask.and.paintbrush")!
            .withRenderingMode(.alwaysTemplate)
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        interactor.loadSomething()
    }

    override func buildViewHierarchy() { 
        view.fillWithSubview(subview: tableView, spacing: .init(top: 16, left: 0, bottom: 0, right: 0), navigationSafeArea: true)
    }
    
    override func setupConstraints() { 
        // template
    }

    override func configureViews() { 
        // template
    }
}

extension OpenAIViewController: OpenAIDisplaying {
    func displaySomething() { 
        // template
    }
}

extension OpenAIViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension OpenAIViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: OpenAICell = tableView.makeCell(indexPath: indexPath, accessoryType: .disclosureIndicator)
        cell.render(bots[indexPath.row])
        return cell
    }
}
