import SwiftUI
import MapKit

struct MapCard: View {
    
    let concert: Concert
    
    var body: some View {
        Button {
            openAddressInMaps(address: concert.venueAddress)
        } label: {
            VStack(alignment: .leading, spacing: 0) {
                Map(initialPosition: MapCameraPosition.region( MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: concert.latitude, longitude: concert.longitude), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))), interactionModes: [])
                    .frame(height: 175)
                    .clipped()
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(concert.venueName)
                        .font(.system(size: 20, type: .SemiBold))
                        .minimumScaleFactor(0.75)
                        .lineLimit(1)
                    
                    Text(concert.generalLocation)
                        .font(.system(size: 17, type: .Regular))
                        .foregroundStyle(.gray)
                        .minimumScaleFactor(0.75)
                        .lineLimit(1)
                    
                }
                .padding(15)
            }
            .containerRelativeFrame(.horizontal) { size, axis in
                size - 30
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.card)
                    .shadow(color: .black.opacity(0.2), radius: 5)
                    
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    func openAddressInMaps(address: String) {
            let formattedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let url = URL(string: "http://maps.apple.com/?q=\(formattedAddress)")!
            
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
}

#Preview {
    NavigationStack {
        MapCard(concert: hotConcerts[0])
    }
}
