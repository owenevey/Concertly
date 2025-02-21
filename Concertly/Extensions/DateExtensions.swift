import Foundation

extension Date {
    
    private static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        return formatter
    }()
    
    private func format(with dateFormat: String, timeZoneIdentifier: String? = nil) -> String {
        Date.dateFormatter.dateFormat = dateFormat
        
        if let timeZoneIdentifier = timeZoneIdentifier, let timeZone = TimeZone(identifier: timeZoneIdentifier) {
            Date.dateFormatter.timeZone = timeZone
        } else {
            Date.dateFormatter.timeZone = .current
        }
        
        return Date.dateFormatter.string(from: self)
    }
    
    // am
    func meridiemFormat(timeZoneIdentifier: String? = nil) -> String {
        return format(with: "a", timeZoneIdentifier: timeZoneIdentifier).lowercased()
    }
    
    // 9:41
    func timeFormat(timeZoneIdentifier: String? = nil) -> String {
        return format(with: "h:mm", timeZoneIdentifier: timeZoneIdentifier)
    }
    
    // 9:41 am
    func timeFormatAMPM(timeZoneIdentifier: String? = nil) -> String {
        return format(with: "h:mm a", timeZoneIdentifier: timeZoneIdentifier)
    }
    
    // Oct 18
    func shortFormat(timeZoneIdentifier: String? = nil) -> String {
        return format(with: "MMM d", timeZoneIdentifier: timeZoneIdentifier)
    }
    
    // Oct 18, 2024
    func shortFormatWithYear(timeZoneIdentifier: String? = nil) -> String {
        return format(with: "MMM d, yyyy", timeZoneIdentifier: timeZoneIdentifier)
    }
    
    // Fri, Oct 18
    func mediumFormat(timeZoneIdentifier: String? = nil) -> String {
        return format(with: "E, MMM d", timeZoneIdentifier: timeZoneIdentifier)
    }
    
    // 10/18/2024
    func traditionalFormat(timeZoneIdentifier: String? = nil) -> String {
        return format(with: "MM/dd/yyyy", timeZoneIdentifier: timeZoneIdentifier)
    }
    
    // 2024-10-18
    func EuropeanFormat(timeZoneIdentifier: String? = nil) -> String {
        return format(with: "yyyy-MM-dd", timeZoneIdentifier: timeZoneIdentifier)
    }
    
    // Oct
    func shortMonthFormat(timeZoneIdentifier: String? = nil) -> String {
        return format(with: "MMM", timeZoneIdentifier: timeZoneIdentifier)
    }
    
    // Friday, February 7, 2025
    func fullWeekdayFormat(timeZoneIdentifier: String? = nil) -> String {
        return format(with: "EEEE, MMMM d, yyyy", timeZoneIdentifier: timeZoneIdentifier)
    }
    
    // 18
    func dayNumber(timeZoneIdentifier: String? = nil) -> String {
        return format(with: "d", timeZoneIdentifier: timeZoneIdentifier)
    }
}
