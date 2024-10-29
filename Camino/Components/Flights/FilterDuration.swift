import SwiftUI

struct FilterDuration: View {
    
    @Binding var durationFilter: Int
    
    @Environment(\.dismiss) var dismiss
    
    var durationRange: DurationRange
    
    init(durationFilter: Binding<Int>, durationRange: DurationRange) {
        self._durationFilter = durationFilter
        self.durationRange = durationRange
    }
    
    var body: some View {
        VStack {
            Text("Duration")
                .font(Font.custom("Barlow-SemiBold", size: 20))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            let sliderValue = Binding<Double>(
                get: { Double(durationFilter) },
                set: { newValue in
                    durationFilter = Int(newValue)
                }
            )
            
            // Use the binding for the Slider
            Slider(value: sliderValue, in: Double(durationRange.min)...Double(durationRange.max), step: 1)
            
            Text(minsToHrMins(minutes: durationFilter))
                .font(Font.custom("Barlow-SemiBold", size: 20))
                .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Text("Done")
                    .font(Font.custom("Barlow-SemiBold", size: 18))
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
    VStack {
            // Create a DurationRange instance
            let durationRange = DurationRange(min: 0, max: 600) // Set min and max as needed

            FilterDuration(durationFilter: .constant(300), durationRange: durationRange)
        }
    .background(Color("Background"))
    .border(Color.red)
    .frame(maxHeight: 400)
}
