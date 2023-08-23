import UIKit

public class TextLabel: UILabel {
    public init() {
        super.init(frame: .zero)
    }
    
    public init(font: UIFont) {
        super.init(frame: .zero)
        self.font = font
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
