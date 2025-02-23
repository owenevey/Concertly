import SwiftUI

struct ChooseAirportView: View {
    
    @StateObject private var viewModel = AirportSearchViewModel()
    
    @AppStorage("Home Airport") private var homeAirport: String = ""
    
    @FocusState private var isTextFieldFocused: Bool
    
    func onTap(airport: SuggestedAirport) {
        homeAirport = airport.code
    }
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("Now, select your home airport")
                    .font(.system(size: 23, type: .SemiBold))
                    .foregroundStyle(.accent)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ConcertlySearchBar(content: {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .fontWeight(.semibold)
                        TextField("Search", text: $viewModel.searchQuery)
                            .submitLabel(.done)
                            .disableAutocorrection(true)
                            .focused($isTextFieldFocused)
                            .font(.system(size: 18, type: .Regular))
                            .padding(.trailing)
                    }
                })
                .padding(.vertical, 15)
                
                ScrollView(showsIndicators: false) {
                    switch viewModel.airportsResponse.status {
                    case .success:
                        if let airports = viewModel.airportsResponse.data {
                            if airports.isEmpty {
                                VStack(spacing: 10) {
                                    Image(systemName: "airplane")
                                        .font(.system(size: 20))
                                        .fontWeight(.semibold)
                                    
                                    Text("No Airports")
                                        .font(.system(size: 18, type: .Regular))
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 250)
                                .transition(.opacity)
                            } else {
                                VStack(spacing: 5) {
                                    ForEach(airports, id: \.code) { airportResult in
                                        
                                        NavigationLink(destination: ChooseArtistsView()) {
                                                HStack(spacing: 20) {
                                                    Image(systemName: "airplane")
                                                        .font(.system(size: 20))
                                                    
                                                    VStack(alignment: .leading) {
                                                        Text(airportResult.name)
                                                            .font(.system(size: 18, type: .Medium))
                                                        Text("\(airportResult.city), \(airportResult.country)")
                                                            .font(.system(size: 16, type: .Regular))
                                                            .foregroundStyle(.gray3)
                                                    }
                                                    
                                                    Spacer()
                                                    
                                                    Text(airportResult.code)
                                                        .font(.system(size: 18, type: .Medium))
                                                }
                                                .padding(.vertical, 5)
                                                .padding(.horizontal, 10)
                                                .contentShape(Rectangle())
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                            .simultaneousGesture(TapGesture().onEnded {
                                                homeAirport = airportResult.code
                                            })
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .transition(.opacity)
                            }
                        }
                    case .loading:
                        LoadingView()
                            .frame(height: 250)
                            .frame(maxWidth: .infinity)
                            .transition(.opacity)
                    case .error:
                        ErrorView(text: "Error fetching airports", action: { await viewModel.getSuggestedAirports() })
                            .frame(height: 250)
                            .frame(maxWidth: .infinity)
                            .transition(.opacity)
                    case .empty:
                        EmptyView()
                            .frame(maxWidth: .infinity)
                            .transition(.opacity)
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 15)
//            .padding(.top, 30)
        }
        .navigationBarHidden(true)
        .disableSwipeBack(true)
        .onAppear {
            isTextFieldFocused = true
        }
    }
}

#Preview {
    ChooseAirportView()
}


