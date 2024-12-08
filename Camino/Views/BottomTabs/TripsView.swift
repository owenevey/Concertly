import SwiftUI

struct TripsView: View {
    
    var body: some View {
        VStack {
            Text("Trips!")
                .font(.system(size: 18, type: .SemiBold))
                .background(Color.background)
            Spacer()
        }
        
    }
}

#Preview {
    TripsView()
}
