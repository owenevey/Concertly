import SwiftUI

struct HidingHeaderView<Header: View, FiltersBar: View, ScrollContent: View>: View {
    
    let header: () -> Header
    let filtersBar: () -> FiltersBar
    let scrollContent: () -> ScrollContent
    
    @State private var naturalScrollOffset: CGFloat = 0
    @State private var lastNaturalOffset: CGFloat = 0
    @State private var headerOffset: CGFloat = 0
    @State private var isScrollingUp: Bool = false
    
    var body: some View {
        GeometryReader {
            
            let safeArea = $0.safeAreaInsets
            
            let HeaderHeight: CGFloat = 60
            let filtersBarHeight: CGFloat = 64 // subtract one so divider shows
            
            ScrollView {
                scrollContent()
                    .frame(maxWidth: .infinity)
            }
            .background(Color("Background"))
            .safeAreaInset(edge: .top, spacing: 0) {
                VStack(spacing: 0) {
                    header()
                        .zIndex(1)
                    filtersBar()
                        .offset(y: -headerOffset)
                }
            }
            .onScrollGeometryChange(for: CGFloat.self) { proxy in
                let maxHeight = proxy.contentSize.height - proxy.containerSize.height
                return max(min(proxy.contentOffset.y + (safeArea.top + HeaderHeight) + filtersBarHeight, maxHeight), 0)
            } action: { oldValue, newValue in
                self.isScrollingUp = oldValue < newValue
                headerOffset = min(max(newValue - lastNaturalOffset, 0), filtersBarHeight)
                
                naturalScrollOffset = newValue
            }
            .onScrollPhaseChange({ oldPhase, newPhase in
                if !newPhase.isScrolling && (headerOffset != 0 || headerOffset != filtersBarHeight) {
                    withAnimation(.snappy(duration: 0.25, extraBounce: 0)) {
                        if (headerOffset > (filtersBarHeight * 0.5 ) && naturalScrollOffset > filtersBarHeight) {
                            headerOffset = filtersBarHeight
                        } else {
                            headerOffset = 0
                        }
                        lastNaturalOffset = naturalScrollOffset - headerOffset
                    }
                }
            })
            .onChange(of: isScrollingUp, { oldValue, newValue in
                lastNaturalOffset = naturalScrollOffset - headerOffset
            })
            
            
            
        }
    }
}

#Preview {
    let concertViewModel = ConcertViewModel(concert: hotConcerts[0])
    
    FlightsView(concertViewModel: concertViewModel)
}
