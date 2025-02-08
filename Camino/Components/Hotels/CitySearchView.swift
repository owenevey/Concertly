import SwiftUI

struct CitySearchView: View {
    
    @Environment(\.dismiss) var dismiss
    @FocusState private var isTextFieldFocused: Bool
    @StateObject private var viewModel = CitySearchViewModel()
    
    @AppStorage("Home Lat") private var homeLat: Double = 40.71417
    @AppStorage("Home Long") private var homeLong: Double = -74.00583
    
    @Binding var location: String
    var title: String?
    
    var topPadding: CGFloat {
        if title == "Home City" {
            return 0
        }
        return 15
    }
    
    func onTap(city: SuggestedCity) {
        if title == "Home City" {
            homeLat = city.latitude
            homeLong = city.longitude
        }
        
        if let stateCode = city.stateCode {
            location = "\(city.name), \(stateCode)"
        } else {
            location = "\(city.name), \(city.countryName)"
        }
        
        dismiss()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                BackButton(showX: title != "Home City")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, -15)
                
                if let title = title {
                    Text(title)
                        .font(.system(size: 18, type: .Medium))
                } else {
                    Text("City Search")
                        .font(.system(size: 18, type: .Medium))
                }
                
                
                Color.clear
                    .frame(height: 0)
                    .frame(maxWidth: .infinity)
            }
            
            CaminoSearchBar(content: {
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
            .padding(.top, 10)
            .padding(.bottom, 20)
            
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
                                    .font(.system(size: 18, type: .Regular))
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 250)
                            .transition(.opacity)
                        } else {
                            VStack(spacing: 5) {
                                ForEach(cities) { city in
                                    Button {
                                        onTap(city: city)
                                    }
                                    label: {
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
        .padding([.leading, .trailing], 15)
        .padding(.top, topPadding)
        .background(Color.background)
        .navigationBarHidden(true)
        .onAppear {
            isTextFieldFocused = true
        }
    }
}

#Preview {
    @Previewable @State var city: String = "SAN"
    
    CitySearchView(location: $city)
}


