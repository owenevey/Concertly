import SwiftUI

struct testHeader: View {
    var place: Place
    var body: some View {
        ScrollView {
            ZStack(alignment: .top) {
                VStack {
                    TabView {
                        ForEach(place.images, id: \.self) { imageUrl in
                            if let url = URL(string: imageUrl) {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    Color.foreground
                                }
                                .frame(width: UIScreen.main.bounds.width)
                                .frame(height: 300)
                                .clipped()
                                .border(.green, width: 3)
                                
                            }
                        }
                    }
                    .border(.red, width: 1)
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                    .frame(height: 300)
                    Spacer()
                }
                
                VStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 300)
                    Rectangle()
                        .frame(height: 700)
                        .border(.blue, width: 3)
                }
            }
            .ignoresSafeArea()
        }
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    let testPlace = Place(
        name: "Seattle",
        shortDescription: "Famous for the Space Needle and vibrant coffee culture.",
        longDescription: "Known for its iconic Space Needle, vibrant coffee culture, and stunning natural surroundings. With a booming tech industry and cultural attractions, it’s a city full of energy and creativity.",
        images: [
            "https://uploads.visitseattle.org/2024/02/26114037/VS_base.jpg",
            "https://harrell.seattle.gov/wp-content/uploads/sites/23/2023/12/DSC_3910-Edit-Edit.jpg"
        ],
        cityName: "Seattle, WA",
        countryName: "United States",
        latitude: 47.6062,
        longitude: -122.3321
    )
    
    NavigationStack {
        testHeader(place: testPlace)
            .navigationBarHidden(true)
    }
}
