import SwiftUI

struct ExploreView: View {
    
    @State private var concerts: [Concert] = []
    @State private var textInput = ""
    
    var body: some View {
        ImageHeaderScrollView(headerContent: ExploreHeader(), showBackButton: false) {
            VStack(spacing: 15) {
                VStack {
                    Spacer()
                    
                    VStack {
                        HStack {
                            Text("What adventures\nawait?")
                                .font(.system(size: 30, type: .Bold))
                                .foregroundStyle(.white)
                                .frame(alignment: .leading)
                                .shadow(color: .black.opacity(0.6), radius: 3)
                            Spacer()
                        }
                        
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.gray1)
                            .shadow(color: .black.opacity(0.6), radius: 3)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .overlay(
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                    TextField("Search", text: $textInput)
                                        .font(.system(size: 18, type: .Regular))
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
            .background(Color.background)
        }
        .background(Color.background)
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
