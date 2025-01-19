import SwiftUI

struct EditHotelsSearch: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var showSheet = false
    
    @Binding var fromDate: Date
    @Binding var toDate: Date
    @Binding var location: String
    
    @State var tempFromDate: Date
    @State var tempToDate: Date
    @State var tempLocation: String
    
    private var maxDate: Date? {
        Calendar.current.date(byAdding: .month, value: 6, to: Date.now)
    }
    
    init(fromDate: Binding<Date>, toDate: Binding<Date>, location: Binding<String>) {
        _fromDate = fromDate
        _toDate = toDate
        _location = location
        
        _tempFromDate = State(initialValue: fromDate.wrappedValue)
        _tempToDate = State(initialValue: toDate.wrappedValue)
        _tempLocation = State(initialValue: location.wrappedValue)
    }
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Edit Search")
                .font(.system(size: 20, type: .SemiBold))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Button {
                showSheet = true
            } label: {
                CaminoSearchBar {
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                            .fontWeight(.semibold)
                        Text(tempLocation)
                            .font(.system(size: 18, type: .Regular))
                            .foregroundStyle(.primary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            
            if let maxDate = maxDate {
                Divider()
                    .frame(height: 2)
                    .overlay(.gray2)
                
                HStack(spacing: 30) {
                    DatePicker("", selection: $tempFromDate, in: Date.now...maxDate, displayedComponents: .date)
                        .labelsHidden()
                    
                    Image(systemName: "arrow.right")
                        .fontWeight(.semibold)
                    
                    DatePicker("", selection: $tempToDate, in: tempFromDate...maxDate, displayedComponents: .date)
                        .labelsHidden()
                }
            }
            
            
            CaminoButton(label: "Search") {
                fromDate = tempFromDate
                toDate = tempToDate
                location = tempLocation
                
                dismiss()
            }
            .padding(.top, 10)
            
        }
        .padding(15)
        .sheet(isPresented: $showSheet) {
            CitySearchView(location: $tempLocation)
        }
    }
}




#Preview {
    @Previewable @State var fromDate = Date.now
    @Previewable @State var toDate = Date.now
    @Previewable @State var location = "Denver, CO"
    
    return EditHotelsSearch(
        fromDate: $fromDate,
        toDate: $toDate,
        location: $location
    )
    .background(Color.background)
    .border(Color.red)
}
