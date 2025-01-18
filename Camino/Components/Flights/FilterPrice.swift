import SwiftUI

struct FilterPrice: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var priceFilter: Int
    var flightPrices: [Int]
    
    var maxPrice: Int {
        return flightPrices.max() ?? 0
    }
    
    init(priceFilter: Binding<Int>, flightPrices: [Int]) {
        self._priceFilter = priceFilter
        self.flightPrices = flightPrices
    }
    
    var body: some View {
        FilterSheet(filter: $priceFilter, defaultFilter: maxPrice, title: "Price") {
            VStack(spacing: 25) {
                SliderFilter(values: flightPrices, filter: $priceFilter)
                    .frame(width: nil, height: 100, alignment: .center)
                    .padding(.horizontal, 25)
                
                Text("Max Price: $\(priceFilter)")
                    .font(.system(size: 20, type: .Regular))
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
}

#Preview {
    @Previewable @State var price = 50
    return VStack {
        FilterPrice(priceFilter: $price, flightPrices: [10, 15, 30, 40, 55, 75, 85, 95])
    }
    .background(Color.background)
    .border(Color.red)
    //    .frame(maxHeight: 400)
}
