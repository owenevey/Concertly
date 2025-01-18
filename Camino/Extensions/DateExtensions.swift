import Foundation

extension Date {
    
    private static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        return formatter
    }()
    
    // am
    func meridiemFormat() -> String {
        Date.dateFormatter.dateFormat = "a"
        return Date.dateFormatter.string(from: self).lowercased()
    }
    
    // 9:41
    func timeFormat() -> String {
        Date.dateFormatter.dateFormat = "h:mm"
        return Date.dateFormatter.string(from: self)
    }
    
    // 9:41
    func timeFormatAMPM() -> String {
        Date.dateFormatter.dateFormat = "h:mm a"
        return Date.dateFormatter.string(from: self)
    }
    
    // Oct 18
    func shortFormat() -> String {
        Date.dateFormatter.dateFormat = "MMM d"
        return Date.dateFormatter.string(from: self)
    }
    
    // Fri, Oct 18
    func mediumFormat() -> String {
        Date.dateFormatter.dateFormat = "E, MMM d"
        return Date.dateFormatter.string(from: self)
    }
    
    // 10/18/2024
    func traditionalFormat() -> String {
        Date.dateFormatter.dateFormat = "MM/dd/yyyy"
        return Date.dateFormatter.string(from: self)
    }
    
    // Oct
    func shortMonthFormat() -> String {
        Date.dateFormatter.dateFormat = "MMM"
        return Date.dateFormatter.string(from: self)
    }
    
    // 18
    func dayNumber() -> String {
        Date.dateFormatter.dateFormat = "d"
        return Date.dateFormatter.string(from: self)
    }
}
