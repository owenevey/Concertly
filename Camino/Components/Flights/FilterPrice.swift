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
        VStack {
            Text("Duration")
                .font(.system(size: 20, type: .SemiBold))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            
            VStack(spacing: 20) {
                SliderFilter(values: flightPrices, filter: $priceFilter)
                    .frame(width: nil, height: 100, alignment: .center)
                    .padding(.horizontal, 25)
                
                
                Text("Max Price: $\(priceFilter)")
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
    @Previewable @State var price = 50
    return VStack {
        FilterPrice(priceFilter: $price, flightPrices: [10, 15, 30, 40, 55, 75, 85, 95])
    }
    .background(Color("Background"))
    .border(Color.red)
    .frame(maxHeight: 400)
}
