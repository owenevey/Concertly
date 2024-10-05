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
            .padding(.horizontal, 15)
            .padding(.vertical, 2)
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
                .font(Font.custom("Barlow-SemiBold", size: 15))
                .padding(.vertical, 10)
                .padding(.horizontal, 15)
                .background(
                    Capsule(style: .continuous)
                        .stroke(Color(UIColor.lightGray), style: StrokeStyle(lineWidth: 1))
                        .fill(.card)
                )
        }.buttonStyle(PlainButtonStyle())
    }
}
