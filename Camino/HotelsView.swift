import SwiftUI

struct HotelsView: View {
    
    let fromDate: Date?
    let toDate: Date?
    
    var body: some View {
        VStack {
            Text("Hotels View!")
            if let fromDate = fromDate, let toDate = toDate {
                Text("From \(fromDate.formatted(date: .abbreviated, time: .omitted)) to \(toDate.formatted(date: .abbreviated, time: .omitted))")
            }
        }
    }
}

#Preview {
    HotelsView(fromDate: Date.now, toDate: Date.now)
}
