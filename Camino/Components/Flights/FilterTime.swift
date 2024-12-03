import SwiftUI

struct FilterTime: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var timeFilter: Int
    var flightTimes: [Int]
    
    var latestTime: Int {
        return flightTimes.max() ?? 0
    }
    
    var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }
    
    func formattedTime(from minutes: Int) -> String {
        let referenceDate = Date(timeIntervalSince1970: 0)
        
        guard let date = Calendar.current.date(byAdding: .minute, value: minutes, to: referenceDate) else {
            return ""
        }
        
        let dateTimeFormatter = DateFormatter()
        dateTimeFormatter.dateFormat = "MMM dd, h:mm a"
        
        return dateTimeFormatter.string(from: date)
    }

    
    var body: some View {
        VStack {
            Text("Time")
                .font(.system(size: 20, type: .SemiBold))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            VStack(spacing: 20) {
                SliderFilter(values: flightTimes, filter: $timeFilter)
                    .frame(width: nil, height: 100, alignment: .center)
                    .padding(.horizontal, 25)
                
                Text("Latest Arrival Time: \(formattedTime(from: timeFilter))")
                    .font(.system(size: 20, type: .Medium))
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Text("Done")
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
    @Previewable @State var time = 600
    return VStack {
        FilterTime(timeFilter: $time, flightTimes: [300, 450, 600, 720, 900, 1140])
    }
    .background(Color("Background"))
    .border(Color.red)
    .frame(maxHeight: 400)
}
