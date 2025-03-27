import SwiftUI
import MapKit
import FirebaseAnalytics

struct MapCard: View {
    
    let addressToSearch: String
    let latitude: Double
    let longitude: Double
    let delta: Double
    
    var body: some View {
        Button {
            Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
                AnalyticsParameterItemName: "open_address_in_maps",
                AnalyticsParameterContentType: "cont",
            ])
            openAddressInMaps(address: addressToSearch)
        } label: {
                Map(initialPosition: MapCameraPosition.region( MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta))), interactionModes: [])
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
        MapCard(addressToSearch: hotConcerts[0].venueAddress, latitude: hotConcerts[0].latitude, longitude: hotConcerts[0].longitude, delta: 0.01)
    }
    .padding(15)
}
