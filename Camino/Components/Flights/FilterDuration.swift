import SwiftUI

struct FilterDuration: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var durationFilter: Int
    var flightDurations: [Int]
    
    var maxDuration: Int {
        return flightDurations.max() ?? Int.max
    }
    
    init(durationFilter: Binding<Int>, flightDurations: [Int]) {
        self._durationFilter = durationFilter
        self.flightDurations = flightDurations
    }
    
    var body: some View {
        FilterSheet(filter: $durationFilter, defaultFilter: maxDuration, title: "Duration") {
            VStack(spacing: 25) {
                SliderFilter(values: flightDurations, filter: $durationFilter)
                    .frame(width: nil, height: 100, alignment: .center)
                    .padding(.horizontal, 25)
                
                Text("Max Duration: " + minsToHrMins(minutes: durationFilter))
                    .font(.system(size: 20, type: .Regular))
                    .frame(maxWidth: .infinity, alignment: .center)
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
