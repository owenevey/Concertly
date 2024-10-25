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
            
            if #available(iOS 18.0, *) {
                ScrollView {
                    
                    scrollContent()
                    
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
            
            else {
                // Fallback on earlier versions
            }
        }
    }
}

//#Preview {
//    HidingHeaderView(
//        header: {
//            // Replace with your custom TopNavBar view
//            Text("Top Nav Bar")
//                .frame(maxWidth: .infinity)
//                .background(Color.red)
//        },
//        filtersBar: {
//            // Replace with your custom FiltersBar view
//            Text("Filters Bar")
//                .frame(maxWidth: .infinity)
//                .background(Color.green)
//        },
//        scrollContent: {
//            VStack(spacing: 15) {
//                ForEach(0..<7, id: \.self) { index in
//                    Rectangle()
//                        .fill(.blue)
//                        .frame(width: 300, height: 100) // Customize the size
//                        .padding(.bottom, 10)
//                }
//            }
//            .padding(15)
//        }
//    )
//}
