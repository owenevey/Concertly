import SwiftUI

struct SavedView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel: SavedViewModel
    
    @State private var offset: CGFloat = 0
    @State private var isSearchBarVisible: Bool = true
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                Image(colorScheme == .light ? .savedBlobsLight : .savedBlobsDark)
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width, height: 250 + max(0, -offset - geometry.safeAreaInsets.top))
                    .scaledToFill()
                    .transformEffect(.init(translationX: 0, y: -max(0, offset + geometry.safeAreaInsets.top)))
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 15) {
                        
                        HStack(alignment: .top) {
                            Text("Saved")
                                .font(.system(size: 30, type: .Bold))
                                .foregroundStyle(.accent)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Circle()
                                .fill(Color.foreground)
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Image(systemName: "bell")
                                        .font(.system(size: 20))
                                        .fontWeight(.semibold)
                                )
                        }
                        .shadow(color: .black.opacity(0.1), radius: 5)
                        .padding(.horizontal, 15)
                        .frame(width: UIScreen.main.bounds.width)
                        
                        LazyVStack(spacing: 15) {
                            if viewModel.savedConcerts.isEmpty {
                                VStack(spacing: 10) {
                                    Image(systemName: "music.note")
                                        .font(.system(size: 20))
                                        .fontWeight(.semibold)
                                    
                                    Text("No saved concerts")
                                        .font(.system(size: 18, type: .Regular))
                                }
                                .frame(height: 250)
                            } else {
                                ForEach(viewModel.savedConcerts) { concert in
                                    SavedConcertCard(concert: concert)
                                }
                            }
                        }
                        .shadow(color: .black.opacity(0.2), radius: 5)
                    }
                    
                    Spacer()
                }
                .padding(.top, geometry.safeAreaInsets.top)
                .onScrollGeometryChange(for: CGFloat.self) { geo in
                    return geo.contentOffset.y
                } action: { oldValue, newValue in
                    offset = newValue
                    withAnimation(.linear(duration: 0.1)) {
                        if newValue > -20 {
                            //change numbers
                            isSearchBarVisible = false
                        } else {
                            isSearchBarVisible = true
                        }
                    }
                }
                
                ExploreHeader()
                    .opacity(isSearchBarVisible ? 0 : 1)
                    .padding(.top, geometry.safeAreaInsets.top)
            }
            .ignoresSafeArea(edges: .top)
        }
        .background(Color.background)
        .onAppear {
            Task {
                await viewModel.getSavedConcerts()
            }
        }
        .refreshable {
            Task {
                await viewModel.getSavedConcerts()
            }
        }
    }
}

#Preview {
    NavigationStack {
        SavedView(viewModel: SavedViewModel())
    }
}
