import SwiftUI

struct ConcertView: View {
    let concert: Concert
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 15) {
                AsyncImage(url: URL(string: concert.imageUrl)) { image in
                    image.resizable()
                } placeholder: {
                    Color.red
                }
                .scaledToFill()
                .containerRelativeFrame(.horizontal) { size, axis in
                    size - 30
                }
                .frame(height: 250)
                .overlay(
                    VStack {
                        Spacer()
                        HStack {
                            Text(concert.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .padding()
                            Spacer()
                        }
                    }.background(
                        LinearGradient(colors: [.clear, .black.opacity(0.8)], startPoint: UnitPoint(x: 0.5, y: 0.6), endPoint: .bottom)
                    )
                )
                .cornerRadius(20)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("🗓️ October 20")
                        .font(.headline)
                    Text("🏟️ \(concert.venue.name)")
                        .font(.headline)
                    Text("💸 $\(Int(concert.minPrice.rounded())) - $\(Int(concert.maxPrice.rounded()))")
                        .font(.headline)
                }
                .padding(15)
                .frame(maxWidth: .infinity, alignment: .leading)
                .containerRelativeFrame(.horizontal) { size, axis in
                    size - 30
                }
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 242 / 255, green: 245 / 255, blue: 248 / 255))
                )
                
                
                AsyncImage(url: URL(string: concert.seatmapImageUrl)) { image in
                    image.resizable()
                    
                } placeholder: {
                    Color.red
                }
                .cornerRadius(20)
                .scaledToFit()
                .padding()
                
                .containerRelativeFrame(.horizontal) { size, axis in
                    size - 30
                }
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 242 / 255, green: 245 / 255, blue: 248 / 255))
                )
                .frame(maxWidth: .infinity, alignment: .leading)
                .containerRelativeFrame(.horizontal) { size, axis in
                    size - 30
                }
                .overlay(
                    VStack {
                        Spacer()
                        HStack {
                            Circle()
                                .frame(width: 75, height: 75)
                                .foregroundColor(.white)
                                .overlay(
                                    AsyncImage(url: URL(string: concert.venue.imageUrl)) { image in
                                        image.resizable()
                                    } placeholder: {
                                        Color.red
                                    }
                                        .scaledToFit()
                                        .frame(maxWidth: 60, maxHeight: 60)
                                    
                                ).clipShape(Circle())
                            Text("Go to venue")
                                .foregroundStyle(.white)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        .padding()
                    }.background(
                        LinearGradient(colors: [.clear, .black.opacity(0.8)], startPoint: UnitPoint(x: 0.5, y: 0.6), endPoint: .bottom)
                    )
                ).cornerRadius(20)
                    .clipped()
                
                
                
                Button {
                    print("Plan trip tapped!")
                } label: {
                    Text("Plan Trip")
                }.buttonStyle(.borderedProminent)
                
                
                
                
                
                Spacer()
            }
            .containerRelativeFrame(.horizontal) { size, axis in
                size
            }
        }
    }
}

#Preview {
    ConcertView(concert: hotConcerts[0])
}
