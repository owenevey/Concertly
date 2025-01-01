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
                    TextField("Search", text: $viewModel.searchQuery)
                        .submitLabel(.done)
                        .disableAutocorrection(true)
                        .focused($isTextFieldFocused)
                        .font(.system(size: 18, type: .Regular))
                        .padding(.trailing)
                }
            })
            .padding(.top)
            .padding(.bottom, 20)
            
            
            switch viewModel.citiesResponse.status {
            case .success:
                if let cities = viewModel.citiesResponse.data?.suggestedCities {
                    
                    VStack(spacing: 20) {
                        ForEach(cities, id: \.self) { city in
                            Button {
                                location = city
                                dismiss()
                            }
                            label: {
                                HStack(spacing: 0) {
                                    Image(systemName: "airplane")
                                        .font(.system(size: 20))
                                        .padding(.horizontal, 20)
                                    
                                    VStack(alignment: .leading) {
                                        Text(city)
                                            .font(.system(size: 18, type: .Medium))
                                        Text(city)
                                            .font(.system(size: 16, type: .Regular))
                                    }
                                    
                                    Spacer()
                                    
                                    Text(city)
                                        .font(.system(size: 18, type: .Medium))
                                        .padding(.horizontal, 20)
                                }
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .transition(.opacity)
                }
            case .loading:
                LoadingView()
                    .frame(height: 250)
                    .transition(.opacity)
            case .error:
                ErrorView(text: "Error fetching cities", action: { await viewModel.getSuggestedCities() })
                    .frame(height: 250)
                    .transition(.opacity)
            default:
                EmptyView()
                    .transition(.opacity)
            }
            Spacer()
        }
        .padding(15)
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


