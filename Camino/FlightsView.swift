import SwiftUI

struct FlightsView: View {
    
    
    let fromDate: Date?
    let toDate: Date?
    
    @State var presentSheet = false
    
    @State private var naturalScrollOffset: CGFloat = 0
    @State private var lastNaturalOffset: CGFloat = 0
    @State private var headerOffset: CGFloat = 0
    @State private var isScrollingUp: Bool = false
    
    var body: some View {
        GeometryReader {
            
            let safeArea = $0.safeAreaInsets
            let headerHeight: CGFloat = 66
            
            if #available(iOS 18.0, *) {
                ScrollView {
                    VStack(spacing: 10) {
                        FlightItem(airline: "American", airlineLogo: "https://www.gstatic.com/flights/airline_logos/70px/AA.png", startTime: "9:15", endTime: "6:00")
                        FlightItem(airline: "Delta", airlineLogo: "https://www.gstatic.com/flights/airline_logos/70px/DL.png", startTime: "12:10", endTime: "6:40")
                        FlightItem(airline: "Frontier", airlineLogo: "https://www.gstatic.com/flights/airline_logos/70px/F9.png", startTime: "9:15", endTime: "11:11")
                        FlightItem(airline: "JetBlue", airlineLogo: "https://www.gstatic.com/flights/airline_logos/70px/B6.png", startTime: "10:15", endTime: "6:00")
                        FlightItem(airline: "American", airlineLogo: "https://www.gstatic.com/flights/airline_logos/70px/AA.png", startTime: "9:15", endTime: "6:00")
                        FlightItem(airline: "Delta", airlineLogo: "https://www.gstatic.com/flights/airline_logos/70px/DL.png", startTime: "12:10", endTime: "6:40")
                        FlightItem(airline: "Frontier", airlineLogo: "https://www.gstatic.com/flights/airline_logos/70px/F9.png", startTime: "9:15", endTime: "11:11")
                        FlightItem(airline: "JetBlue", airlineLogo: "https://www.gstatic.com/flights/airline_logos/70px/B6.png", startTime: "10:15", endTime: "6:00")
                        FlightItem(airline: "American", airlineLogo: "https://www.gstatic.com/flights/airline_logos/70px/AA.png", startTime: "9:15", endTime: "6:00")
                        FlightItem(airline: "Delta", airlineLogo: "https://www.gstatic.com/flights/airline_logos/70px/DL.png", startTime: "12:10", endTime: "6:40")
                        FlightItem(airline: "Frontier", airlineLogo: "https://www.gstatic.com/flights/airline_logos/70px/F9.png", startTime: "9:15", endTime: "11:11")
                        FlightItem(airline: "JetBlue", airlineLogo: "https://www.gstatic.com/flights/airline_logos/70px/B6.png", startTime: "10:15", endTime: "6:00")
                        FlightItem(airline: "American", airlineLogo: "https://www.gstatic.com/flights/airline_logos/70px/AA.png", startTime: "9:15", endTime: "6:00")
                        FlightItem(airline: "Delta", airlineLogo: "https://www.gstatic.com/flights/airline_logos/70px/DL.png", startTime: "12:10", endTime: "6:40")
                        FlightItem(airline: "Frontier", airlineLogo: "https://www.gstatic.com/flights/airline_logos/70px/F9.png", startTime: "9:15", endTime: "11:11")
                        FlightItem(airline: "JetBlue", airlineLogo: "https://www.gstatic.com/flights/airline_logos/70px/B6.png", startTime: "10:15", endTime: "6:00")
                    }
                    .padding(10)
                }
                .overlay(content: {
                    Text("\(naturalScrollOffset)")
                })
                .background(Color("Background"))
                .safeAreaInset(edge: .top, spacing: 0) {
                    VStack(spacing: 0) {
                        TopNavBar()
                            .zIndex(1)
                        FiltersBar()
                            .offset(y: -headerOffset)
                    }
                    
                }
                .onScrollGeometryChange(for: CGFloat.self) { proxy in
                    let maxHeight = proxy.contentSize.height - proxy.containerSize.height
                    return max(min(proxy.contentOffset.y + (safeArea.top + 75) + headerHeight, maxHeight), 0)
                } action: { oldValue, newValue in
                    self.isScrollingUp = oldValue < newValue
                    headerOffset = min(max(newValue - lastNaturalOffset, 0), headerHeight)
                    
                    naturalScrollOffset = newValue
                }
                .onScrollPhaseChange({ oldPhase, newPhase in
                    if !newPhase.isScrolling && (headerOffset != 0 || headerOffset != headerHeight) {
                        withAnimation(.snappy(duration: 0.25, extraBounce: 0)) {
                            if (headerOffset > (headerHeight * 0.5 ) && naturalScrollOffset > headerHeight) {
                                headerOffset = headerHeight
                            } else {
                                headerOffset = 0
                            }
                            lastNaturalOffset = naturalScrollOffset - headerOffset
                        }
                    }
                })
                .onChange(of: isScrollingUp, { oldValue, newValue in
                    lastNaturalOffset = naturalScrollOffset - headerOffset
                    print("last natural offset: \(lastNaturalOffset)")
                })
                
                
                
                
            } else {
                // Fallback on earlier versions
            }
            
            
            
            
            
            
        }
        
    }
    
    
    
    struct FiltersBar: View {
        var body: some View {
            VStack(spacing: 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(FlightFilter.allCases, id: \.self) { filter in
                            Button {
                                print("\(filter.title) tapped!")
                                //                            presentSheet = true
                            } label: {
                                
                                HStack {
                                    if filter.title == "Sort" {
                                        Image(systemName: "pencil")
                                    }
                                    Text(filter.title)
                                        .font(Font.custom("Barlow-Regular", size: 15))
                                    
                                }
                                .padding(13)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.gray.opacity(0.6), style: StrokeStyle(lineWidth: 2))
                                        .padding(1)
                                )
                            }
                            //                        .sheet(isPresented: $presentSheet) {
                            //                            Text(filter.title)
                            //                                .presentationDetents([.medium])
                            //                        }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(10)
                }.frame(height: 66)
                
                Divider()
                    .frame(height: 1)
                    .background(.gray)
                
            }
            .frame(height: 67)
            .background(Color("Background"))
        }
    }
}

#Preview {
    FlightsView(fromDate: Date.now, toDate: Date.now)
}



struct TopNavBar: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        HStack {
            HStack {
                Button(action: {dismiss()}) {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(.ultraThinMaterial)
                        .frame(width: 50, height: 50)
                        .overlay(
                            Image(systemName: "arrow.backward")
                                .font(.system(size: 20))
                        )
                        .padding(.leading, 20)
                }
                .buttonStyle(PlainButtonStyle())
                Spacer()
            }
            .frame(maxWidth: .infinity)
            Spacer()
            VStack {
                HStack {
                    Text("SYD - LAX")
                        .font(Font.custom("Barlow-Bold", size: 20))
                    Image(systemName: "pencil")
                        .font(.system(size: 16))
                }
                Text("Oct 9 - Oct 17")
                    .font(Font.custom("Barlow-SemiBold", size: 15))
            }
            Spacer()
            VStack{}
                .frame(maxWidth: .infinity)
        }
        .frame(height: 70)
        .padding(.bottom, 5)
        .background(Color("Background"))
    }
}
