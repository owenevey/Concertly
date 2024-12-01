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
                .font(Font.custom("Barlow-SemiBold", size: 20))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            
            VStack(spacing: 20) {
                SliderFilter(values: flightPrices, filter: $priceFilter)
                    .frame(width: nil, height: 100, alignment: .center)
                    .padding(.horizontal, 25)
                
                
                Text("Max Price: $\(priceFilter)")
                    .font(Font.custom("Barlow-SemiBold", size: 20))
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            
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
    @Previewable @State var price = 50
    return VStack {
        FilterPrice(priceFilter: $price, flightPrices: [10, 15, 30, 40, 55, 75, 85, 95])
    }
    .background(Color("Background"))
    .border(Color.red)
    .frame(maxHeight: 400)
}
