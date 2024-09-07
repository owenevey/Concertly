import SwiftUI

struct ExplorePills: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack(spacing: 15){
                
                TransportButton(title: "🏨 Hotels")
                TransportButton(title: "✈️ Flights")
                TransportButton(title: "🚊 Trains")
                TransportButton(title: "🚍 Busses")

            }
            .padding(15)
        }
    }
}

#Preview {
    ExplorePills()
}

struct TransportButton: View {
    var title: String
    var body: some View {
        Button {
            print("Pressed \(title)")
        } label: {
            Text(title)
                .font(.subheadline)
                .padding(.vertical, 10)
                .padding(.horizontal, 15)
                .foregroundColor(.black)
                .overlay(
                    Capsule(style: .continuous)
                        .stroke(Color(UIColor.lightGray), style: StrokeStyle(lineWidth: 1))
                )
        }
    }
}
