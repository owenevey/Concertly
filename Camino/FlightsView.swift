import SwiftUI

struct FlightsView: View {
    
    let fromDate: Date?
    let toDate: Date?
    
    var body: some View {
        VStack {
            Text("Flights!")
            if let fromDate = fromDate, let toDate = toDate {
                Text("From \(fromDate.formatted(date: .abbreviated, time: .omitted)) to \(toDate.formatted(date: .abbreviated, time: .omitted))")
            }
        }
    }
}

#Preview {
    FlightsView(fromDate: Date.now, toDate: Date.now)
}
