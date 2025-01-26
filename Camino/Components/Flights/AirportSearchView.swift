import SwiftUI

struct AirportSearchView: View {
    
    @Environment(\.dismiss) var dismiss
    @FocusState private var isTextFieldFocused: Bool
    @StateObject private var viewModel = AirportSearchViewModel()
    
    @Binding var airportCode: String
    var title: String
    
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
                
                Text(title)
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
                switch viewModel.airportsResponse.status {
                case .success:
                    if let airports = viewModel.airportsResponse.data {
                        
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
        .padding([.top, .leading, .trailing], 15)
        .background(Color.background)
        .onAppear {
            isTextFieldFocused = true
        }
    }
}

#Preview {
    @Previewable @State var airportCode: String = "SAN"
    
    AirportSearchView(airportCode: $airportCode, title: "Destination")
}


