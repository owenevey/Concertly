import SwiftUI

struct AirportSearchView: View {
    
    @Environment(\.dismiss) var dismiss
    @FocusState private var isTextFieldFocused: Bool
    
    @Binding var airportCode: String
    var title: String
    @StateObject private var viewModel = AirportSearchViewModel()
    
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
                
                Text(title)
                    .font(.system(size: 18, type: .Medium))
                
                Color.clear
                    .frame(height: 0)
                    .frame(maxWidth: .infinity)
            }
            
            RoundedRectangle(cornerRadius: 15)
                .fill(.gray1)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField("Search", text: $viewModel.searchQuery)
                            .submitLabel(.done)
                            .disableAutocorrection(true)
                            .focused($isTextFieldFocused)
                            .font(.system(size: 18, type: .Regular))
                            .padding(.trailing)
                    }
                        .padding()
                )
                .padding(.top)
                .padding(.bottom, 20)
            
            
            switch viewModel.airportsResponse.status {
            case .success:
                if let airports = viewModel.airportsResponse.data?.suggestedAirports {
                    
                    VStack(spacing: 20) {
                        ForEach(airports, id: \.code) { airportResult in
                            Button {
                                airportCode = airportResult.code
                                dismiss()
                            }
                            label: {
                                HStack(spacing: 0) {
                                    Image(systemName: "airplane")
                                        .font(.system(size: 20))
                                        .padding(.horizontal, 20)
                                    
                                    VStack(alignment: .leading) {
                                        Text(airportResult.name)
                                            .font(.system(size: 18, type: .Medium))
                                        Text("\(airportResult.city), \(airportResult.country)")
                                            .font(.system(size: 16, type: .Regular))
                                    }
                                    
                                    Spacer()
                                    
                                    Text(airportResult.code)
                                        .font(.system(size: 18, type: .Medium))
                                        .padding(.horizontal, 20)
                                }
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    
                }
            case .loading:
                LoadingView()
                    .frame(height: 250)
            case .error:
                ErrorView(text: "Error fetching airports", action: { await viewModel.getSuggestedAirports() })
                .frame(height: 250)
            default:
                EmptyView()
            }
            Spacer()
        }
        .padding()
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


