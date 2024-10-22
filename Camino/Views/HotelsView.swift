import SwiftUI

struct HotelsView: View {
    
    @Binding var fromDate: Date
    @Binding var toDate: Date
    
    var body: some View {
        VStack {
            Text("Hotels View!")
                Text("From \(fromDate.formatted(date: .abbreviated, time: .omitted)) to \(toDate.formatted(date: .abbreviated, time: .omitted))")
            
        }
    }
}

#Preview {
    HotelsView(fromDate: .constant(Date.now), toDate: .constant(Date.now))
}
