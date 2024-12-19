import SwiftUI

struct HotelsFilterBar: View {
    
    @Binding var priceFilter: Int
    var hotelPrices: [Int]
    
    @State var presentSheet = false
    @State var selectedFilter: HotelFilter
    
    init(priceFilter: Binding<Int>, hotelPrices: [Int]) {
        self._priceFilter = priceFilter
        self.hotelPrices = hotelPrices
        
        self._selectedFilter = State(initialValue: .price(priceFilter, hotelPrices))
    }
    
    private func isFilterActive(_ filter: HotelFilter) -> Bool {
        switch filter {
        case .price:
            let maxPrice = hotelPrices.max() ?? 0
            return priceFilter < maxPrice
        default:
            return false
        }
    }
    
    private var isAnyFilterActive: Bool {
        HotelFilter.allCases(
            priceFilter: $priceFilter,
            hotelPrices: hotelPrices
        ).contains { isFilterActive($0) } }
    
    private func resetFilters() {
        priceFilter = hotelPrices.max() ?? Int.max
    }
    
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(HotelFilter.allCases(priceFilter: $priceFilter, hotelPrices: hotelPrices), id: \.title) { filter in
                        Button {
                            selectedFilter = filter
                            presentSheet = true
                        } label: {
                            HStack {
                                if filter.title == "Sort" {
                                    Image(systemName: "line.3.horizontal.decrease")
                                }
                                Text(filter.title)
                                    .font(.system(size: 14, type: .Regular))
                            }
                            .padding(13)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(isFilterActive(filter) ? Color.primary : .gray2, style: StrokeStyle(lineWidth: 2))
                                    .padding(2)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    if isAnyFilterActive {
                        Button {
                            withAnimation(.easeInOut) {
                                resetFilters()
                            }
                        } label: {
                            HStack {
                                Image(systemName: "xmark")
                                
                                Text("Clear")
                                    .font(.system(size: 14, type: .Regular))
                            }
                            .padding(10)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .transition(.opacity)
                    }
                }
                .padding(10)
                .sheet(isPresented: $presentSheet) {
                    selectedFilter.destinationView
                        .presentationDetents([.medium])
                        .presentationBackground(Color.background)
                }
            }
            Divider()
                .frame(height: 1)
                .overlay(.gray2)
        }
        .frame(height: 65)
        .background(Color.foreground)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
    }
}

#Preview {

    @Previewable @State var priceFilter = 300
    
    let hotelPrices = [100, 200, 300, 400, 500]
    
    return VStack {
        Spacer()
        HotelsFilterBar(
            priceFilter: $priceFilter,
            hotelPrices: hotelPrices
        )
        Spacer()
    }
    .background(Color.gray3)
}
