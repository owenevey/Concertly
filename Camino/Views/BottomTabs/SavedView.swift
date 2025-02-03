import SwiftUI

struct SavedView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel: NearbyViewModel = NearbyViewModel()
    
    @State private var hasAppeared: Bool = false
    @State private var offset: CGFloat = 0
    @State private var isSearchBarVisible: Bool = true
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                Image(colorScheme == .light ? .savedBlobsLight : .savedBlobsDark)
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width, height: 200 + max(0, -offset))
                    .scaledToFill()
                    .transformEffect(.init(translationX: 0, y: -max(0, offset)))
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        VStack(spacing: 15) {
                            
                            HStack(alignment: .top) {
                                Text("Saved Trips")
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
                                switch viewModel.nearbyConcertsResponse.status {
                                case .loading, .empty:
                                    if viewModel.nearbyConcerts.isEmpty {
                                        ForEach(0..<6, id: \.self) { _ in
                                            FallbackSavedConcertCard()
                                        }
                                    } else {
                                        ForEach(viewModel.nearbyConcerts) { concert in
                                            SavedConcertCard(concert: concert)
                                        }
                                    }
                                    
                                case .success:
                                    if viewModel.nearbyConcerts.isEmpty {
                                        ForEach(0..<6, id: \.self) { _ in
                                            ErrorNearbyConcertCard()
                                        } // PUT IN TEXT HERE
                                    } else {
                                        ForEach(viewModel.nearbyConcerts) { concert in
                                            FallbackSavedConcertCard()
                                        }
                                    }
                                    
                                case .error:
                                    if viewModel.nearbyConcerts.isEmpty {
                                        ForEach(0..<6, id: \.self) { _ in
                                            ErrorSavedConcertCard()
                                        }
                                    } else {
                                        ForEach(0..<6, id: \.self) { _ in
                                            ErrorSavedConcertCard()
                                        }
                                        // renderCards(for: data) NOTE: Keep for debugging
                                    }
                                }
                            }
                            .shadow(color: .black.opacity(0.2), radius: 5)
                        }
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
            if !hasAppeared {
                Task {
                    await viewModel.getNearbyConcerts()
                }
                hasAppeared = true
            }
        }
                .refreshable {
                    Task {
                        await viewModel.getNearbyConcerts()
                    }
                }
    }
}

#Preview {
    NavigationStack {
        SavedView()
    }
}
