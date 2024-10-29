import SwiftUI

struct FlightsView: View {
    
    @ObservedObject var concertViewModel: ConcertViewModel
    @StateObject var viewModel: FlightsViewModel
    
    init(concertViewModel: ConcertViewModel) {
        self.concertViewModel = concertViewModel
        
        _viewModel = StateObject(wrappedValue: FlightsViewModel(
            fromDate: concertViewModel.tripStartDate,
            toDate: concertViewModel.tripEndDate,
            flightsResponse: concertViewModel.flightsResponse
        ))
    }
    
    var body: some View {
        HidingHeaderView (
            header: {
                FlightsHeader(viewModel: viewModel, fromDate: $viewModel.fromDate, toDate: $viewModel.toDate, fromAirport: $viewModel.fromAirport, toAirport: $viewModel.toAirport)
            },
            filtersBar: {
                FlightsFiltersBar(sortMethod: $viewModel.sortFlightsMethod, allAirlines: $viewModel.airlineFilter, stopsFilter: $viewModel.stopsFilter, durationFilter: $viewModel.durationFilter, durationRange: viewModel.durationRange)
            },
            scrollContent: {
                VStack(spacing: 15) {
                    ForEach(viewModel.filteredFlights) { flightItem in
                        FlightCard(flightItem: flightItem)
                    }
                }
                .padding(15)
            }
        )
        .onAppear {
            viewModel.airlineFilter = extractAirlineData(from: viewModel.flightsResponse.data)
        }
        .onChange(of: viewModel.fromDate) {
            concertViewModel.tripStartDate = viewModel.fromDate
        }
        .onChange(of: viewModel.toDate) {
            concertViewModel.tripEndDate = viewModel.toDate
        }
    }
    
    func extractAirlineData(from flightData: FlightsResponse?) -> [String: (imageURL: String, isEnabled: Bool)] {
        var airlineDict: [String: (imageURL: String, isEnabled: Bool)] = [:]
        
        guard let flights = flightData else {
            return airlineDict
        }
        
        // Loop through all the best flights
        for flightItem in flights.bestFlights {
            // Loop through the individual flights in each item
            for flight in flightItem.flights {
                let airlineName = flight.airline
                let airlineLogo = flight.airlineLogo
                
                // If the airline doesn't already exist in the dictionary, add it
                if airlineDict[airlineName] == nil {
                    airlineDict[airlineName] = (imageURL: airlineLogo, isEnabled: true)
                }
            }
        }
        
        for flightItem in flights.otherFlights {
            // Loop through the individual flights in each item
            for flight in flightItem.flights {
                let airlineName = flight.airline
                let airlineLogo = flight.airlineLogo
                
                // If the airline doesn't already exist in the dictionary, add it
                if airlineDict[airlineName] == nil {
                    airlineDict[airlineName] = (imageURL: airlineLogo, isEnabled: true)
                }
            }
        }
        
        return airlineDict
    }
}

#Preview {
    let concertViewModel = ConcertViewModel(concert: hotConcerts[0])
    
    FlightsView(concertViewModel: concertViewModel)
}
