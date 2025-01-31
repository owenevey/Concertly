import SwiftUI
import MapKit

struct MapCard: View {
    
    let addressToSearch: String
    let latitude: Double
    let longitude: Double
    
    var body: some View {
        Button {
            openAddressInMaps(address: addressToSearch)
        } label: {
                Map(initialPosition: MapCameraPosition.region( MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))), interactionModes: [])
                    .frame(height: 175)
                    .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    func openAddressInMaps(address: String) {
        if let formattedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            if let url = URL(string: "http://maps.apple.com/?q=\(formattedAddress)") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        MapCard(addressToSearch: hotConcerts[0].venueAddress, latitude: hotConcerts[0].latitude, longitude: hotConcerts[0].longitude)
    }
    .padding(15)
}
