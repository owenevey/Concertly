import SwiftUI

struct ChooseCityView: View {
    
    @StateObject private var viewModel = CitySearchViewModel()
    
    @AppStorage(AppStorageKeys.homeCity.rawValue) private var homeCity = ""
    @AppStorage(AppStorageKeys.homeLat.rawValue) private var homeLat: Double = 0
    @AppStorage(AppStorageKeys.homeLong.rawValue) private var homeLong: Double = 0
    
    @FocusState private var isTextFieldFocused: Bool
    
    func onTap(city: SuggestedCity) {
        homeLat = city.latitude
        homeLong = city.longitude
        
        if let stateCode = city.stateCode {
            homeCity = "\(city.name), \(stateCode)"
        } else {
            homeCity = "\(city.name), \(city.countryName)"
        }
    }
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("First, select your city")
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
                            .font(.system(size: 17, type: .Regular))
                            .padding(.trailing)
                    }
                })
                .padding(.vertical, 15)
                
                ScrollView(showsIndicators: false) {
                    switch viewModel.citiesResponse.status {
                    case .success:
                        if let cities = viewModel.citiesResponse.data {
                            if cities.isEmpty {
                                VStack(spacing: 10) {
                                    Image(systemName: "building.2.fill")
                                        .font(.system(size: 20))
                                        .fontWeight(.semibold)
                                    
                                    Text("No Cities")
                                        .font(.system(size: 17, type: .Regular))
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 250)
                                .transition(.opacity)
                            } else {
                                VStack(spacing: 5) {
                                    ForEach(cities) { city in
                                        NavigationLink(destination: ChooseAirportView()) {
                                            HStack(spacing: 20) {
                                                Image(systemName: "building.2.fill")
                                                    .font(.system(size: 20))
                                                
                                                VStack(alignment: .leading) {
                                                    if let state = city.stateCode {
                                                        Text("\(city.name), \(state)")
                                                            .font(.system(size: 18, type: .Medium))
                                                    } else {
                                                        Text(city.name)
                                                            .font(.system(size: 18, type: .Medium))
                                                    }
                                                    
                                                    Text(city.countryName)
                                                        .font(.system(size: 16, type: .Regular))
                                                        .foregroundStyle(.gray3)
                                                }
                                            }
                                            .padding(.vertical, 5)
                                            .padding(.horizontal, 10)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .contentShape(Rectangle())
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                        .simultaneousGesture(TapGesture().onEnded {
                                            onTap(city: city)
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
                        ErrorView(text: "Error fetching cities", action: { await viewModel.getSuggestedCities() })
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
        }
        .navigationBarHidden(true)
        .disableSwipeBack(true)
        .onAppear {
            isTextFieldFocused = true
        }
    }
}

#Preview {
    NavigationStack {
        ChooseCityView()
    }
}


