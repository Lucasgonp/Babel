import Foundation

extension Date {
    func lastMessageDate() -> String {
        let formatter = DateFormatter()
        let seconds = Date().timeIntervalSince(self)
        
        var elapsed = String()
        if seconds < 24 * 60 * 60 {
            formatter.dateFormat = "HH:mm"
            elapsed = formatter.string(from: self)
        } else if seconds < 24 * 60 * 60 * 7 {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE"
            elapsed = formatter.string(from: self)
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            elapsed = formatter.string(from: self)
        }
        
        
        return elapsed
    }
    
    func time() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
    
    func date() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: self)
    }
    
    func isInSameDayOf(date: Date) -> Bool {
        self.date() == date.date()
    }
    
    func stringDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMMyyyyHHmmss"
        return formatter.string(from: self)
    }
    
    func interval(ofComponent comp: Calendar.Component, from date: Date) -> Float {
        guard  let start = Calendar.current.ordinality(of: comp, in: .era, for: date) else { 
            return 0
        }
        guard  let end = Calendar.current.ordinality(of: comp, in: .era, for: self) else {
            return 0
        }

        return Float(start - end)
    }
}


