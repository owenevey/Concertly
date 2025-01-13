import SwiftUI
import MapKit

struct MapCard: View {
    
    let addressToSearch: String
    let latitude: Double
    let longitude: Double
    let name: String
    let generalLocation: String
    
    var body: some View {
        Button {
            openAddressInMaps(address: addressToSearch)
        } label: {
            VStack(alignment: .leading, spacing: 0) {
                Map(initialPosition: MapCameraPosition.region( MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))), interactionModes: [])
                    .frame(height: 175)
                    .clipped()
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(name)
                        .font(.system(size: 20, type: .SemiBold))
                        .minimumScaleFactor(0.85)
                        .lineLimit(1)
                    
                    Text(generalLocation)
                        .font(.system(size: 17, type: .Regular))
                        .foregroundStyle(.gray3)
                        .minimumScaleFactor(0.85)
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
                    .fill(Color.foreground)
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
        MapCard(addressToSearch: hotConcerts[0].venueAddress, latitude: hotConcerts[0].latitude, longitude: hotConcerts[0].longitude, name: hotConcerts[0].venueName, generalLocation: hotConcerts[0].cityName)
    }
}
