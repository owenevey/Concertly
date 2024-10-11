import SwiftUI

struct FlightItem: View {
    
    let airline: String
    let airlineLogo: String
    let startTime: String
    let endTime: String
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(alignment: .top, spacing: 15) {
                HStack {
                    Circle()
                        .fill(.white)
                        .frame(width: 40, height: 40)
                        .overlay(
                    AsyncImage(url: URL(string: airlineLogo)) { image in
                        image
                            .resizable()
                    } placeholder: {
                        Image(systemName: "photo.fill")
                    }
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    )
                    
                    
                    VStack(alignment: .leading) {
                        Text(airline)
                            .font(Font.custom("Barlow-SemiBold", size: 20))
                        Text("Airbus A350-900")
                            .font(Font.custom("Barlow-SemiBold", size: 15))
                            .foregroundStyle(.gray)
                    }
                }
                
                Spacer()
                
                HStack(spacing: 5) {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 15))
                        .foregroundStyle(.gray)
                    
                    Text("13h 45m")
                        .font(Font.custom("Barlow-SemiBold", size: 15))
                        .foregroundStyle(.gray)
                }
            }
            
            //////////
            
            HStack {
                VStack(alignment: .leading) {
                    HStack(alignment: .bottom, spacing: 0) {
                        Text(startTime)
                            .font(Font.custom("Barlow-SemiBold", size: 35))
                        Text("am")
                            .font(Font.custom("Barlow-SemiBold", size: 25))
                            .padding(.bottom, 2)
                    }
                    HStack(spacing: 5) {
                        Image(systemName: "arrow.up.right.circle.fill")
                            .font(.system(size: 15))
                        Text("SYD")
                            .font(Font.custom("Barlow-SemiBold", size: 15))
                            .minimumScaleFactor(0.5)
                    }
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                Image(systemName: "airplane")
                Spacer()
                
                VStack(alignment: .trailing) {
                    HStack(alignment: .bottom, spacing: 0) {
                        Text(endTime)
                            .font(Font.custom("Barlow-SemiBold", size: 35))
                        Text("pm")
                            .font(Font.custom("Barlow-SemiBold", size: 25))
                            .padding(.bottom, 2)
                    }
                    HStack(spacing: 5) {
                        Image(systemName: "arrow.down.right.circle.fill")
                            .font(.system(size: 15))
                        Text("LAX")
                            .font(Font.custom("Barlow-SemiBold", size: 15))
                            .minimumScaleFactor(0.5)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            
            Divider()
                .frame(height: 1)
                .background(.gray)
            
            HStack {
                HStack {
                    Image(systemName: "calendar")
                        .font(.system(size: 15))
                        .foregroundStyle(.gray)
                    Text("Sep 17 - Nonstop")
                        .font(Font.custom("Barlow-SemiBold", size: 15))
                        .foregroundStyle(.gray)
                }
                Spacer()
                Text("$1,435")
                    .font(Font.custom("Barlow-SemiBold", size: 20))
            }
            
            
            
            
            
        }
        .padding(15)
        .contentShape(RoundedRectangle(cornerRadius: 20))
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.card)
                .padding(1)
        )
        
    }
}

#Preview {
    NavigationStack {
        ScrollView(showsIndicators: false) {
            
            VStack(spacing: 15) {
                FlightItem(airline: "American", airlineLogo: "https://www.gstatic.com/flights/airline_logos/70px/AA.png", startTime: "9:15", endTime: "6:00")
                FlightItem(airline: "Delta", airlineLogo: "https://www.gstatic.com/flights/airline_logos/70px/DL.png", startTime: "12:10", endTime: "6:40")
                FlightItem(airline: "Frontier", airlineLogo: "https://www.gstatic.com/flights/airline_logos/70px/F9.png", startTime: "9:15", endTime: "11:11")
                FlightItem(airline: "JetBlue", airlineLogo: "https://www.gstatic.com/flights/airline_logos/70px/B6.png", startTime: "10:15", endTime: "6:00")
            }
            .padding(.horizontal, 15)
        }
        .background(Color("Background"))
//        .containerRelativeFrame(.horizontal) { size, axis in
//            size - 30
//        }
        .navigationTitle("Flights")
        
    }
    .background(Color("Background"))
}
