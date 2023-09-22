import Foundation

extension Date {
    func lastMessageDate() -> String {
        let formatter = DateFormatter()
        let seconds = Date().timeIntervalSince(self)
        
        var elapsed = String()
        if seconds < 24 * 60 * 60 {
            formatter.dateFormat = "hh:mm"
            elapsed = formatter.string(from: self)
        } else if seconds < 24 * 60 * 60 * 7 {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE"
            elapsed = formatter.string(from: self)
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yy"
            elapsed = formatter.string(from: self)
        }
        
        
        return elapsed
    }
}
