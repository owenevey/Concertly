import SwiftUI

struct CitySearchView: View {
    
    @Environment(\.dismiss) var dismiss
    @FocusState private var isTextFieldFocused: Bool
    @StateObject private var viewModel = CitySearchViewModel()
    
    @Binding var location: String
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    dismiss()
                }
                label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .semibold))
                }
                .buttonStyle(PlainButtonStyle())
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("City Search")
                    .font(.system(size: 18, type: .Medium))
                
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
                    if let cities = viewModel.citiesResponse.data?.suggestedCities {
                        
                        VStack(spacing: 5) {
                            ForEach(cities, id: \.name) { city in
                                Button {
                                    if let state = city.stateCode {
                                        location = "\(city.name), \(state)"
                                    } else {
                                        location = "\(city.name), \(city.countryCode)"
                                    }
                                    dismiss()
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
        .padding([.top, .leading, .trailing], 15)
        .background(Color.background)
        .onAppear {
            isTextFieldFocused = true
        }
    }
}

#Preview {
    @Previewable @State var city: String = "SAN"
    
    CitySearchView(location: $city)
}


