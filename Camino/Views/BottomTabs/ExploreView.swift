import SwiftUI

struct ExploreView: View {
    
    @State private var concerts: [Concert] = []
    @State private var textInput = ""
    
    var body: some View {
//        ScrollView(showsIndicators: false) {
        ImageHeaderScrollView(headerContent: ExploreHeader(), showBackButton: false) {
            VStack(spacing: 15) {
                VStack {
//                    HStack {
//                        Spacer()
//                        Circle()
//                            .fill(.card)
//                            .frame(width: 40, height: 40)
//                            .overlay(
//                                Image(systemName: "bell.fill")
//                                    .foregroundStyle(.accent)
//                            )
//                            .padding(.trailing, 20)
//                            .padding(.top, 50)
//                    }
                    
                    Spacer()
                    
                    VStack {
                        HStack {
                            Text("What adventures\nawait?")
                                .font(Font.custom("Barlow-Bold", size: 30))
                                .foregroundStyle(.white)
                                .frame(alignment: .leading)
                                .shadow(color: .black.opacity(0.6), radius: 3)
                            Spacer()
                        }
                        
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.card)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .overlay(
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                    TextField("Search", text: $textInput)
                                        .font(Font.custom("Barlow-Regular", size: 18))
                                        .padding(.trailing)
                                }.padding()
                            )
                    }
                    .padding(20)
                }
                .frame(height: 300)
                ExplorePills()
                ExploreRow(title: "Suggested Places", data: suggestedPlaces)
                ExploreRow(title: "Trending Concerts", data: concerts)
                ExploreRow(title: "Upcoming Games", data: upcomingGames)
            }
            .padding(.bottom, 90)
            .padding(.top, -300)
            .background(Color("Background"))
        }
        .background(Color("Background"))
        .ignoresSafeArea(edges: .top)
        .task {
            do {
                concerts = try await fetchConcertsFromAPI()
            } catch {
                print("Error fetching concerts")
            }
        }
        .refreshable {
            do {
                concerts = try await fetchConcertsFromAPI()
            } catch {
                print("Error fetching concerts")
            }
        }
    }
}

#Preview {
    NavigationStack {
        ExploreView()
    }
}
