import SwiftUI

struct FilterTime: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var timeFilter: Int
    var flightTimes: [Int]
    
    var latestTime: Int {
        return flightTimes.max() ?? 0
    }
    
    var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }
    
    func formattedTime(from minutes: Int) -> String {
        let referenceDate = Date(timeIntervalSince1970: 0)
        
        guard let date = Calendar.current.date(byAdding: .minute, value: minutes, to: referenceDate) else {
            return ""
        }
        
        let dateTimeFormatter = DateFormatter()
        dateTimeFormatter.dateFormat = "MMM dd, h:mm a"
        
        return dateTimeFormatter.string(from: date)
    }

    
    var body: some View {
        FilterSheet(filter: $timeFilter, title: "Time") {
            VStack {
                Spacer()
                
                VStack(spacing: 20) {
                    SliderFilter(values: flightTimes, filter: $timeFilter)
                        .frame(width: nil, height: 100, alignment: .center)
                        .padding(.horizontal, 25)
                    
                    Text("Arrival Before: \(formattedTime(from: timeFilter))")
                        .font(.system(size: 20, type: .Medium))
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    @Previewable @State var time = 600
    return VStack {
        FilterTime(timeFilter: $time, flightTimes: [300, 450, 600, 720, 900, 1140])
    }
    .background(Color.background)
    .border(Color.red)
    .frame(maxHeight: 400)
}
