import SwiftUI

struct HotelsView: View {
    
    @ObservedObject var concertViewModel: ConcertViewModel
    
    var body: some View {
        VStack {
            Text("Hotels View!")
            Text("From \(concertViewModel.tripStartDate.formatted(date: .abbreviated, time: .omitted)) to \(concertViewModel.tripEndDate.formatted(date: .abbreviated, time: .omitted))")
            
        }
    }
}

#Preview {
    let concertViewModel = ConcertViewModel(concert: hotConcerts[0])
    
    HotelsView(concertViewModel: concertViewModel)
}
