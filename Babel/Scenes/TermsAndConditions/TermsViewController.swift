import UIKit
import DesignKit
import PDFKit

private extension TermsViewController.Layout {
    enum Texts {
        static let title = Strings.TermsAndConditions.title.localized()
    }
}

final class TermsViewController: UIViewController {
    fileprivate enum Layout { }
    
    private lazy var pdfViewer: PDFView = {
        let pdfViewer = PDFView()
        pdfViewer.displayMode = .singlePageContinuous
        pdfViewer.autoScales = true
        pdfViewer.displayDirection = .vertical
        return pdfViewer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }
}

extension TermsViewController: ViewConfiguration {
    func buildViewHierarchy() {
        view.fillWithSubview(subview: pdfViewer, navigationSafeArea: true)
    }

    func configureViews() {
        title = Layout.Texts.title
        view.backgroundColor = Color.backgroundPrimary.uiColor
        
        DispatchQueue.global().async {
            if let path = Bundle.main.path(forResource: "TermsAndConditions", ofType: "pdf") {
                if let pdfDocument = PDFDocument(url: URL(fileURLWithPath: path)) {
                    DispatchQueue.main.async {
                        self.pdfViewer.document = pdfDocument
                    }
                }
            }
        }
    }
}
