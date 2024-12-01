import SwiftUI

struct SliderFilter: View {
    var values: [Int]
    @Binding var filter: Int
    
    var body: some View {
        let minValue = values.min() ?? 0
        let maxValue = values.max() ?? 0
        
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                CustomBarGraph(values: values)
                    .padding(.bottom, 20)
                
                CustomSlider(filter: $filter, minValue: minValue, maxValue: maxValue)
                    .position(x: geometry.size.width / 2.0, y: geometry.size.height)
            }
        }
    }
}


struct CustomSlider: View {
    @Binding var filter: Int
    
    var minValue: Int
    var maxValue: Int
    
    var body: some View {
        GeometryReader { geometry in
            let totalRange = maxValue - minValue
            let normalizedFilter = Double(filter - minValue) / Double(totalRange)
            
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(Color("customGray"))
                    .frame(height: 5)
                    .cornerRadius(5)
                
                Rectangle()
                    .foregroundColor(Color.orange)
                    .frame(width: geometry.size.width * CGFloat(normalizedFilter), height: 5)
                    .cornerRadius(5)
                
                Circle()
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.2), radius: 8)
                    .frame(width: 25, height: 25)
                    .position(x: geometry.size.width * CGFloat(normalizedFilter), y: geometry.size.height / 2.0)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let newPos = value.location.x / geometry.size.width
                                let newValue = minValue + Int(Double(totalRange) * Double(newPos))
                                
                                if newValue > maxValue { filter = maxValue }
                                else if newValue < minValue { filter = minValue }
                                else { filter = newValue }
                            }
                    )
            }
        }
    }
}


struct CustomBarGraph: View {
    var values: [Int]
    
    var bins: [Int: Int] {
        guard let minValue = values.min(), let maxValue = values.max() else { return [:] }
        let totalBins = 10
        let binSize = max(1, (maxValue - minValue) / totalBins)
        
        var bins: [Int: Int] = [:]
        for lowerBound in stride(from: minValue, through: maxValue, by: binSize) {
            bins[lowerBound] = 0
        }
        
        for value in values {
            let binStart = ((value - minValue) / binSize) * binSize + minValue
            bins[binStart, default: 0] += 1
        }
        
        return bins
    }
    
    var maxFrequency: Int {
        bins.values.max() ?? 1
    }
    
    var body: some View {
        GeometryReader { geometry in
            let barWidth = geometry.size.width / CGFloat(bins.count) - 4
            
            HStack(alignment: .bottom, spacing: 4) {
                ForEach(bins.keys.sorted(), id: \.self) { binStart in
                    let frequency = bins[binStart] ?? 0
                    let heightRatio = Double(frequency) / Double(maxFrequency)
                    
                    RoundedRectangle(cornerRadius: 5)
                        .frame(
                            width: barWidth,
                            height: geometry.size.height * CGFloat(heightRatio)
                        )
                        .foregroundColor(Color.orange)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}


#Preview {
    @Previewable @State var filter = 165
    
    return SliderFilter(values: [
        135, 145, 155, 165, 170, 175, 185, 190, 195,
        199,205, 210, 215, 217, 219,265, 270, 275,
        276, 277, 278, 279, 272, 285, 290, 295, 296,
        297, 298, 299, 293, 291,305, 310, 315, 316,
        317, 318, 319, 312, 313, 311],
                        filter: $filter)
    
    .frame(width: nil, height: 100, alignment: .center)
    .padding(.horizontal, 25)
}
