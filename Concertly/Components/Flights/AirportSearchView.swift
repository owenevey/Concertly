import SwiftUI

struct AirportSearchView: View {
    
    @Environment(\.dismiss) var dismiss
    @FocusState private var isTextFieldFocused: Bool
    @StateObject private var viewModel = AirportSearchViewModel()
    
    @Binding var airportCode: String
    var title: String
    
    var topPadding: CGFloat {
        if title == "Home Airport" {
            return 0
        }
        return 15
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                BackButton(showX: title != "Home Airport")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, -15)
                
                Text(title)
                    .font(.system(size: 18, type: .Medium))
                
                Color.clear
                    .frame(height: 0)
                    .frame(maxWidth: .infinity)
            }
            
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
            .padding(.vertical, 10)
            
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
                                    .font(.system(size: 17, type: .Regular))
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 250)
                            .transition(.opacity)
                        } else {
                            VStack(spacing: 5) {
                                ForEach(airports, id: \.code) { airportResult in
                                    Button {
                                        airportCode = airportResult.code
                                        dismiss()
                                    }
                                    label: {
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
                    ErrorView(text: "Error fetching airports", action: {
                        await viewModel.getSuggestedAirports()
                    })
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
    @Previewable @State var airportCode: String = "SAN"
    
    AirportSearchView(airportCode: $airportCode, title: "Destination")
}


