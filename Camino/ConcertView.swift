import SwiftUI
import MapKit

struct ConcertView: View {
    
    var concert: Concert
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 10) {
                    AsyncImage(url: URL(string: concert.imageUrl)) { image in
                        image
                            .resizable()
                    } placeholder: {
                        Image(systemName: "photo.fill")
                    }
                    .scaledToFill()
                    .frame(height: 320)
                    .containerRelativeFrame(.horizontal) { size, axis in
                        size
                    }
//                    .overlay(
//
//                    )
//                    
                    ZStack(alignment: .top) {
                        LinearGradient(colors: [.clear, .black], startPoint: .top, endPoint: .bottom)
                            .frame(height: 60)
                            .opacity(0.7)
                            .padding(.top, -60)
                        VStack {
                            VStack(alignment: .leading, spacing: 5) {
                                Text(concert.name)
                                    .font(Font.custom("Barlow-Bold", size: 30))
                                
                                Text(concert.dateTime.formatted(date: .complete, time: .omitted))
                                    .font(Font.custom("Barlow-SemiBold", size: 17))
                                    .foregroundStyle(.gray)
                            }
                            .padding([.top, .horizontal], 20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Minimum Price Summary")
                                    .font(Font.custom("Barlow-SemiBold", size: 20))
                                    .padding(.bottom, 4)
                                
                                HStack {
                                    Text("✈️ Flight:")
                                        .font(Font.custom("Barlow-SemiBold", size: 17))
                                        .foregroundStyle(.gray)
                                    Spacer()
                                    Text("$330")
                                        .font(Font.custom("Barlow-SemiBold", size: 17))
                                        .foregroundStyle(.gray)
                                }
                                
                                HStack {
                                    Text("🏨 Hotel:")
                                        .font(Font.custom("Barlow-SemiBold", size: 17))
                                        .foregroundStyle(.gray)
                                    Spacer()
                                    Text("$250")
                                        .font(Font.custom("Barlow-SemiBold", size: 17))
                                        .foregroundStyle(.gray)
                                }
                                
                                HStack {
                                    Text("🎟️ Ticket:")
                                        .font(Font.custom("Barlow-SemiBold", size: 17))
                                        .foregroundStyle(.gray)
                                    Spacer()
                                    Text("$\(String(format: "%.0f", concert.minPrice))")
                                        .font(Font.custom("Barlow-SemiBold", size: 17))
                                        .foregroundStyle(.gray)
                                }
                                
                                Divider()
                                
                                HStack {
                                    Text("Total:")
                                        .font(Font.custom("Barlow-SemiBold", size: 17))
                                    Spacer()
                                    Text("$780")
                                        .font(Font.custom("Barlow-SemiBold", size: 17))
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 15)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(alignment: .leading, spacing: 0) {
                                Map(initialPosition: MapCameraPosition.region( MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: Double(concert.venue.latitude)!, longitude: Double(concert.venue.longitude)!), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))), interactionModes: [])
                                    .frame(height: 175)
                                    .cornerRadius(17)
                                    .clipped()
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(concert.venue.name)
                                        .font(Font.custom("Barlow-Bold", size: 20))
                                        .lineLimit(1)
                                    
                                    Text(concert.venue.country)
                                        .font(Font.custom("Barlow-SemiBold", size: 17))
                                        .foregroundStyle(.gray)
                                    
                                }
                                .padding(10)
                            }
                            .padding(8)
                            .containerRelativeFrame(.horizontal) { size, axis in
                                size - 20
                            }
                            
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color("Card"))
                            )
                            
                            
                            Spacer()
                        }
                        .background(Color("Background"))
                        .cornerRadius(25, corners: [.topLeft, .topRight])
                        .padding(.top, -45)
                    }
                }
                .containerRelativeFrame(.horizontal) { size, axis in
                    size
                }
                .padding(.bottom, 90)
                
                
            }
            .background(Color("Background"))
            .ignoresSafeArea(edges: .top)
            
            VStack {
                HStack{
                    Button(action: {dismiss()}) {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(.ultraThinMaterial)
                            .frame(width: 50, height: 50)
                            .overlay(
                                Image(systemName: "arrow.backward")
                                    .font(.system(size: 20))
                            )
                            .padding(.leading, 20)
                    }.buttonStyle(PlainButtonStyle())
                    Spacer()
                }
                Spacer()
            }
            
            ZStack{
                    Button{
                        print("Tapped plan trip")
                    } label: {
                        HStack {
                            Text("Plan Trip")
                                .font(Font.custom("Barlow-SemiBold", size: 20))
                                .foregroundStyle(.white)
                            Image(systemName: "arrow.forward")
                                .foregroundStyle(.white)
                                .fontWeight(.bold)
                        }
                    }
                
                .padding(6)
            }
            .frame(width: 260, height: 60)
            .background(Color("AccentColor"))
            .cornerRadius(35)
            .padding(.horizontal, 26)
            .shadow(radius: 5)
        }
    }
}

#Preview {
    ConcertView(concert: hotConcerts[0])
}
