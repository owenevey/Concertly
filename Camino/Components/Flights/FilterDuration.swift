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
        FilterSheet(filter: $durationFilter, title: "Duration") {
            VStack {
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
            }
        }
    }
}

#Preview {
    @Previewable @State var duration = 50
    return VStack {
        FilterDuration(durationFilter: $duration, flightDurations: [10, 15, 30, 40, 55, 75, 85, 95])
    }
    .background(Color.background)
    .border(Color.red)
    .frame(maxHeight: 400)
}
