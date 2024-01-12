import UIKit
import DesignKit

final class StopWatchView: UIView {
    private let timeRecordingLabel: TextLabel = {
        let text = TextLabel(font: Font.sm.uiFont)
        text.text = "0:00 ⏺"
        text.textAlignment = .right
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
        
    private let dateFormatter : DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    private var timeRecordingStart: TimeInterval?
    
    init() {
        super.init(frame: .zero)
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startCounter() {
        timeRecordingStart = Date().timeIntervalSinceNow + 1
        updateTimeLabel()
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self else {
                return timer.invalidate()
            }
            
            if self.timeRecordingStart != nil {
                self.timeRecordingStart! += 1
                self.updateTimeLabel()
            } else {
                self.stopCounter()
                timer.invalidate()
            }
        }
    }
    
    func stopCounter() {
        self.timeRecordingStart = nil
        self.timeRecordingLabel.text = "0:00 ⏺"
    }
}

extension StopWatchView: ViewConfiguration {
    func buildViewHierarchy() {
        fillWithSubview(subview: timeRecordingLabel, spacing: .init(top: 2, left: 6, bottom: 2, right: 6))
    }
    
    func setupConstraints() { }
    
    func configureViews() {
        backgroundColor = Color.backgroundTertiary.uiColor
    }
}

private extension StopWatchView {
    func updateTimeLabel() {
        guard let timeRecordingStart else { return }
        let timerLabel = dateFormatter.string(from: timeRecordingStart)!.replacingOccurrences(of: "^0(\\d)", with: "$1", options: .regularExpression)
        timeRecordingLabel.text = "\(timerLabel) ⏺"
    }
}
