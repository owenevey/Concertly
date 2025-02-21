import SwiftUI

struct EditFlightsSearch: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var showSheet = false
    @State private var isFromAirport: Bool = true
    
    @Binding var fromAirport: String
    @Binding var toAirport: String
    @Binding var fromDate: Date
    @Binding var toDate: Date
    
    @State var tempFromAirport: String
    @State var tempToAirport: String
    @State var tempFromDate: Date
    @State var tempToDate: Date
    
    private var maxDate: Date? {
        Calendar.current.date(byAdding: .month, value: 6, to: Date.now)
    }
    
    init(fromAirport: Binding<String>, toAirport: Binding<String>, fromDate: Binding<Date>, toDate: Binding<Date>) {
        _fromAirport = fromAirport
        _toAirport = toAirport
        _fromDate = fromDate
        _toDate = toDate
        
        _tempFromAirport = State(initialValue: fromAirport.wrappedValue)
        _tempToAirport = State(initialValue: toAirport.wrappedValue)
        _tempFromDate = State(initialValue: fromDate.wrappedValue)
        _tempToDate = State(initialValue: toDate.wrappedValue)
    }
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Edit Search")
                .font(.system(size: 20, type: .SemiBold))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Button {
                isFromAirport = true
                showSheet = true
            } label: {
                ConcertlySearchBar {
                    HStack {
                        Image(systemName: "airplane.departure")
                            .fontWeight(.semibold)
                        Text(tempFromAirport)
                            .font(.system(size: 18, type: .Regular))
                            .foregroundStyle(.primary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            Button {
                isFromAirport = false
                showSheet = true
            } label: {
                ConcertlySearchBar {
                    HStack {
                        Image(systemName: "airplane.arrival")
                            .fontWeight(.semibold)
                        Text(tempToAirport)
                            .font(.system(size: 18, type: .Regular))
                            .foregroundStyle(.primary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .buttonStyle(PlainButtonStyle())
            
                Divider()
                    .frame(height: 2)
                    .overlay(.gray2)
                
                HStack(spacing: 30) {
                    DatePicker("", selection: $tempFromDate, in: Date.now..., displayedComponents: .date)
                        .labelsHidden()
                    
                    Image(systemName: "arrow.right")
                        .fontWeight(.semibold)
                    
                    DatePicker("", selection: $tempToDate, in: tempFromDate..., displayedComponents: .date)
                        .labelsHidden()
                }
            
            ConcertlyButton(label: "Search") {
                fromDate = tempFromDate
                toDate = tempToDate
                fromAirport = tempFromAirport
                toAirport = tempToAirport
                
                dismiss()
            }
            .padding(.top, 10)
        }
        .padding(15)
        .sheet(isPresented: $showSheet) {
            if isFromAirport {
                AirportSearchView(airportCode: $tempFromAirport, title: "Origin")
            } else {
                AirportSearchView(airportCode: $tempToAirport, title: "Destination")
            }
        }
    }
}




#Preview {
    @Previewable @State var fromAirport = "JFK"
    @Previewable @State var toAirport = "LAX"
    @Previewable @State var fromDate = Date.now
    @Previewable @State var toDate = Date.now
    
    return EditFlightsSearch(
        fromAirport: $fromAirport,
        toAirport: $toAirport,
        fromDate: $fromDate,
        toDate: $toDate
    )
    .background(Color.background)
    .border(Color.red)
}
