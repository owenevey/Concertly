import SwiftUI

struct FlightsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    let fromDate: Date?
    let toDate: Date?
    
    var body: some View {
        VStack(spacing: 0) {
            
            HStack {
                HStack {
                    Button(action: {dismiss()}) {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(.ultraThinMaterial)
                            .frame(width: 50, height: 50)
                            .overlay(
                                Image(systemName: "arrow.backward")
                                    .font(.system(size: 20))
                            )
                            .padding(.leading, 20)
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                Spacer()
                VStack {
                    HStack {
                        Text("SYD - LAX")
                            .font(Font.custom("Barlow-Bold", size: 20))
                        Image(systemName: "pencil")
                            .font(.system(size: 16))
                    }
                    Text("Oct 9 - Oct 17")
                        .font(Font.custom("Barlow-SemiBold", size: 15))
                }
                Spacer()
                VStack{}
                    .frame(maxWidth: .infinity)
            }
            .padding(.bottom, 5)
            .background(.card)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(1..<8, id: \.self) { color in
                        Button {
                            print("filter tapped!")
                        } label: {
                            Text("Stops")
                                .font(Font.custom("Barlow-SemiBold", size: 15))
                                .foregroundStyle(.white)
                                .padding(13)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.gray, style: StrokeStyle(lineWidth: 2))
                                        .padding(1)
                                )
//                                .padding(5)
                        }
                    }
                }
                .padding(10)
            }
            //            .frame(height: 60)
            .background(.card)
            
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 10) {
                    FlightItem(airline: "American", airlineLogo: "https://www.gstatic.com/flights/airline_logos/70px/AA.png", startTime: "9:15", endTime: "6:00")
                    FlightItem(airline: "Delta", airlineLogo: "https://www.gstatic.com/flights/airline_logos/70px/DL.png", startTime: "12:10", endTime: "6:40")
                    FlightItem(airline: "Frontier", airlineLogo: "https://www.gstatic.com/flights/airline_logos/70px/F9.png", startTime: "9:15", endTime: "11:11")
                    FlightItem(airline: "JetBlue", airlineLogo: "https://www.gstatic.com/flights/airline_logos/70px/B6.png", startTime: "10:15", endTime: "6:00")
                }
                .padding(10)
            }
            .background(Color("Background"))
            
            
            
            
        }
        
    }
}

#Preview {
    FlightsView(fromDate: Date.now, toDate: Date.now)
}
