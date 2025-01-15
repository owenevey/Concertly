import SwiftUI

struct HotelsFilterBar: View {
    
    @Binding var sortMethod: SortHotelsEnum
    @Binding var priceFilter: Int
    var hotelPrices: [Int]
    @Binding var ratingFilter: Int
    @Binding var locationRatingFilter: Int
    
    @State var presentSheet = false
    @State var detentHeight: CGFloat = 400
    @State var selectedFilter: HotelFilter
    
    init(sortMethod: Binding<SortHotelsEnum>, priceFilter: Binding<Int>, hotelPrices: [Int], ratingFilter: Binding<Int>, locationRatingFilter: Binding<Int>) {
        self._sortMethod = sortMethod
        self._priceFilter = priceFilter
        self.hotelPrices = hotelPrices
        self._ratingFilter = ratingFilter
        self._locationRatingFilter = locationRatingFilter
        
        self._selectedFilter = State(initialValue: .sort(sortMethod))
    }
    
    private func isFilterActive(_ filter: HotelFilter) -> Bool {
        switch filter {
        case .sort:
            return sortMethod != .recommended
        case .price:
            let maxPrice = hotelPrices.max() ?? 0
            return priceFilter < maxPrice
        case .rating:
            return ratingFilter != 1
        case .locationRating:
            return locationRatingFilter != 1
        default:
            return false
        }
    }
    
    private var isAnyFilterActive: Bool {
        HotelFilter.allCases(sortMethod: $sortMethod, priceFilter: $priceFilter,
                             hotelPrices: hotelPrices, ratingFilter: $ratingFilter, locationRatingFilter: $locationRatingFilter
        ).contains { isFilterActive($0) } }
    
    private func resetFilters() {
        sortMethod = .recommended
        priceFilter = hotelPrices.max() ?? Int.max
        ratingFilter = 1
        locationRatingFilter = 1
    }
    
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(HotelFilter.allCases(sortMethod: $sortMethod, priceFilter: $priceFilter, hotelPrices: hotelPrices, ratingFilter: $ratingFilter, locationRatingFilter: $locationRatingFilter), id: \.title) { filter in
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
                            withAnimation {
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
                        .readHeight()
                        .onPreferenceChange(BottomSheetHeightPreferenceKey.self) { height in
                            if let height {
                                print("gg", height)
                                self.detentHeight = height
                            }
                        }
                        .presentationDetents([.height(self.detentHeight)])
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
            sortMethod: .constant(.recommended),
            priceFilter: $priceFilter,
            hotelPrices: hotelPrices,
            ratingFilter: .constant(1),
            locationRatingFilter: .constant(1)
        )
        Spacer()
    }
    .background(Color.gray3)
}
