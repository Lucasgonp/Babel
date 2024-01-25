import UIKit
import DesignKit

protocol OpenAIDisplaying: AnyObject {
    func displaySomething()
}
private extension OpenAIViewController.Layout {
    enum Texts {
        static let chatBotTitle = Strings.OpenAI.ChatBot.title.localized()
        static let chatBotDescription = Strings.OpenAI.ChatBot.description.localized()
        static let imageGeneratorTitle = Strings.OpenAI.ImageGenerator.title.localized()
        static let imageGeneratorDescription = Strings.OpenAI.ImageGenerator.description.localized()
    }
}

final class OpenAIViewController: ViewController<OpenAIInteractorProtocol, UIView> {
    fileprivate enum Layout { }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(cellType: OpenAICell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var bots = [
        OpenAIDTO(
            name: Layout.Texts.chatBotTitle,
            bio: Layout.Texts.chatBotDescription,
            avatar: ChatBotHelper.Images.chatBotIcon,
            action: { [weak self] in
                self?.interactor.openChatBot()
            }
        ),
        OpenAIDTO(
            name: Layout.Texts.imageGeneratorTitle,
            bio: Layout.Texts.imageGeneratorDescription,
            avatar: ChatBotHelper.Images.imageGeneratorIcon,
            action: {[weak self] in
                self?.interactor.openImageGenerator()
            }
        )
    ]

    override func buildViewHierarchy() { 
        view.fillWithSubview(subview: tableView, spacing: .init(top: 16, left: 0, bottom: 0, right: 0), navigationSafeArea: true)
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
        
        if let cell = tableView.cellForRow(at: indexPath) as? OpenAICell {
            cell.completionHandler?()
        }
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
