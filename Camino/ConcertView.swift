import SwiftUI
import MapKit

struct ConcertView: View {
    
    var concert: Concert
    
    @Environment(\.dismiss) var dismiss
    @State private var hasAppeared: Bool = false
    @State private var offset: CGFloat = 0
    
    @State private var tripStartDate: Date? = nil
    @State private var tripEndDate: Date? = nil
    
    var body: some View {
        ZStack(alignment: .top) {
            
            AsyncImage(url: URL(string: concert.imageUrl)) { image in
                image
                    .resizable()
            } placeholder: {
                Color.gray
                    .frame(height: 300 + max(0, -offset))
            }
            .scaledToFill()
            .frame(height: 300 + max(0, -offset))
            .containerRelativeFrame(.horizontal) { size, axis in
                size
            }
            .transformEffect(.init(translationX: 0, y: -max(0, offset)))
            
            
            if #available(iOS 18.0, *) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: 300)
                        
                        VStack(spacing: 15) {
                            VStack(alignment: .leading, spacing: 5) {
                                Text(concert.name)
                                    .font(Font.custom("Barlow-Bold", size: 30))
                                
                                Text(concert.dateTime.formatted(date: .complete, time: .omitted))
                                    .font(Font.custom("Barlow-SemiBold", size: 17))
                                    .foregroundStyle(.gray)
                            }
                            .padding(.top, 15)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Minimum Price Summary")
                                    .font(Font.custom("Barlow-SemiBold", size: 20))
                                
                                if let startDate = tripStartDate, let endDate = tripEndDate {
                                    Text("\(shortFormat(startDate)) - \(shortFormat(endDate))")
                                        .font(Font.custom("Barlow-SemiBold", size: 17))
                                        .foregroundStyle(.gray)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(spacing: 15) {
                                ForEach((LineItemType.allCases(fromDate: tripStartDate, toDate: tripEndDate, link: concert.url)), id: \.title) { item in
                                    LineItem(item: item, price: concert.minPrice)
                                }
                            }
                            
                            Divider()
                                .frame(height: 2)
                                .background(.card)
                            
                            HStack {
                                Text("Total:")
                                    .font(Font.custom("Barlow-SemiBold", size: 17))
                                Spacer()
                                Text("$780")
                                    .font(Font.custom("Barlow-SemiBold", size: 17))
                            }
                            .padding(.horizontal, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            MapCard(concert: concert)
                        }
                        .padding(.horizontal, 15)
                        .background(Color("Background"))
                    }
                    .containerRelativeFrame(.horizontal) { size, axis in
                        size
                    }
                    .padding(.bottom, 15)
                }
                .ignoresSafeArea(edges: .top)
                .onScrollGeometryChange(for: CGFloat.self) { geo in
                    return geo.contentOffset.y
                } action: { oldValue, newValue in
                    offset = newValue
                }
            } else {
                // Fallback on earlier versions
            }

            
            HStack{
                Button(action: {dismiss()}) {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(.ultraThinMaterial)
                        .frame(width: 50, height: 50)
                        .overlay(
                            Image(systemName: "arrow.backward")
                                .font(.system(size: 20))
                        )
                        .padding(.top, 60)
                        .padding(.leading, 20)
                }
                .buttonStyle(PlainButtonStyle())
                Spacer()
            }
            
//            VStack {
//                Spacer()
//                Button{
//                    print("Tapped plan trip")
//                    let calendar = Calendar.current
//                    if let startDate = tripStartDate {
//                        tripStartDate = calendar.date(byAdding: .day, value: -1, to: startDate)!
//                    }
//                    
//                } label: {
//                    HStack {
//                        Text("Plan Trip")
//                            .font(Font.custom("Barlow-SemiBold", size: 20))
//                            .foregroundStyle(.white)
//                        Image(systemName: "arrow.forward")
//                            .foregroundStyle(.white)
//                            .fontWeight(.bold)
//                    }
//                }
//                
//                .padding(6)
//                .frame(width: 260, height: 60)
//                .background(Color("AccentColor"))
//                .cornerRadius(35)
//                .padding(.horizontal, 26)
//                .shadow(radius: 5)
//            }
        }
        .background(Color("Background"))
        .ignoresSafeArea(edges: .top)
        .onAppear {
            if !hasAppeared {
                let calendar = Calendar.current
                tripStartDate = calendar.date(byAdding: .day, value: -1, to: concert.dateTime)!
                tripEndDate = calendar.date(byAdding: .day, value: 1, to: concert.dateTime)!
                hasAppeared = true
            }
        }
    }
    
    func shortFormat(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d"
        
        return formatter.string(from: date)
    }
}

#Preview {
    NavigationStack {
        ConcertView(concert: hotConcerts[0])
            .navigationBarHidden(true)
    }
}

