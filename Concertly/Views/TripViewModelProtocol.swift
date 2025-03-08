import Foundation

@MainActor
protocol TripViewModelProtocol: ObservableObject {
    var tripStartDate: Date { get set }
    var tripEndDate: Date { get set }
    var latitude: Double { get }
    var longitude: Double { get }
    var closestAirport: String { get set }
    var flightsResponse: ApiResponse<FlightsResponse> { get set }
    var hotelsResponse: ApiResponse<HotelsResponse> { get set }
    var flightsPrice: Int { get set }
    var hotelsPrice: Int { get set }
    var cityName: String { get set }
    func getDepartingFlights() async
    func getHotels() async
}
