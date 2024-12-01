import Foundation

func minsToHrMins(minutes: Int) -> String {
    let hours = minutes / 60
    let remainingMinutes = minutes % 60
    return hours > 0 ? "\(hours)h \(remainingMinutes)m" : "\(remainingMinutes)m"
}
