import SwiftUI

struct EditFlightsSearch: View {
    
    @Environment(\.dismiss) var dismiss
        
        @Binding var fromDate: Date
        @Binding var toDate: Date
        @Binding var fromAirport: String
        @Binding var toAirport: String
        
        @State var tempFromDate: Date
        @State var tempToDate: Date
        @State var tempFromAirport: String
        @State var tempToAirport: String
        
        private var maxDate: Date {
            Calendar.current.date(byAdding: .month, value: 6, to: Date.now) ?? Date.now
        }
        
        init(fromDate: Binding<Date>, toDate: Binding<Date>, fromAirport: Binding<String>, toAirport: Binding<String>) {
            _fromDate = fromDate
            _toDate = toDate
            _fromAirport = fromAirport
            _toAirport = toAirport
            
            _tempFromDate = State(initialValue: fromDate.wrappedValue)
            _tempToDate = State(initialValue: toDate.wrappedValue)
            _tempFromAirport = State(initialValue: fromAirport.wrappedValue)
            _tempToAirport = State(initialValue: toAirport.wrappedValue)
        }
    
    var body: some View {
        VStack {
            Text("Edit Search")
                .font(.system(size: 20, type: .SemiBold))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 15) {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.customGray.opacity(0.5))
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .overlay(
                        HStack {
                            Image(systemName: "airplane.departure")
                            TextField("Departure Airport", text: $tempFromAirport)
                                .font(.system(size: 18, type: .Regular))
                                .padding(.trailing)
                        }.padding()
                    )
                
                RoundedRectangle(cornerRadius: 15)
                    .fill(.customGray.opacity(0.5))
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .overlay(
                        HStack {
                            Image(systemName: "airplane.arrival")
                            TextField("Arrival Airport", text: $tempToAirport)
                                .font(.system(size: 18, type: .Regular))
                                .padding(.trailing)
                        }.padding()
                    )
                Divider()
                    .frame(height: 2)
                    .overlay(.customGray)
                
                VStack {
                    DatePicker(selection: $tempFromDate, in: Date.now...maxDate, displayedComponents: .date) {
                        Text("From")
                            .font(.system(size: 18, type: .Regular))
                    }
                    DatePicker(selection: $tempToDate, in: tempFromDate...maxDate, displayedComponents: .date) {
                        Text("To")
                            .font(.system(size: 18, type: .Regular))
                    }
                }
                .padding(.horizontal, 10)
            }
            
            
            
            Spacer()
            
            Button {
                fromDate = tempFromDate
                toDate = tempToDate
                fromAirport = tempFromAirport
                toAirport = tempToAirport
                
                dismiss()
            } label: {
                Text("Search")
                    .font(.system(size: 18, type: .Medium))
                    .foregroundStyle(.white)
                    .padding(12)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.accent)
                    )
                    .padding(.top)
            }
            .buttonStyle(PlainButtonStyle())
            
        }
        .padding()
    }
}

#Preview {
    @Previewable @State var fromDate = Date.now
    @Previewable @State var toDate = Date.now
    @Previewable @State var fromAirport = "JFK"
    @Previewable @State var toAirport = "LAX"
    
    return EditFlightsSearch(
        fromDate: $fromDate,
        toDate: $toDate,
        fromAirport: $fromAirport,
        toAirport: $toAirport
    )
    .background(Color("Background"))
    .border(Color.red)
    .frame(maxHeight: 400)
}
