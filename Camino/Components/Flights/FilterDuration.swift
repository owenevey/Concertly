import SwiftUI

struct FilterDuration: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var durationFilter: Int
    var flightDurations: [Int]
    
    var maxDuration: Int {
        return flightDurations.max() ?? 0
    }
    
    init(durationFilter: Binding<Int>, flightDurations: [Int]) {
        self._durationFilter = durationFilter
        self.flightDurations = flightDurations
    }
    
    var body: some View {
        VStack {
            Text("Duration")
                .font(.system(size: 20, type: .SemiBold))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            
            VStack(spacing: 20) {
                SliderFilter(values: flightDurations, filter: $durationFilter)
                    .frame(width: nil, height: 100, alignment: .center)
                    .padding(.horizontal, 25)
                
                
                Text("Max Duration: " + minsToHrMins(minutes: durationFilter))
                    .font(.system(size: 20, type: .Medium))
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Text("Done")
                    .font(.system(size: 17, type: .SemiBold))
                    .padding()
                    .frame(width: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .background(
                        RoundedRectangle(cornerRadius: 20)
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
    @Previewable @State var duration = 50
    return VStack {
        FilterDuration(durationFilter: $duration, flightDurations: [10, 15, 30, 40, 55, 75, 85, 95])
    }
    .background(Color("Background"))
    .border(Color.red)
    .frame(maxHeight: 400)
}
