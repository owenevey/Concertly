import SwiftUI

struct ExploreSearchView: View {
    
    @Environment(\.dismiss) var dismiss
    @FocusState private var isTextFieldFocused: Bool
    @StateObject private var viewModel = ExploreSearchViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    dismiss()
                }
                label: {
                    Image(systemName: "arrow.backward")
                        .font(.system(size: 18, weight: .semibold))
                }
                .buttonStyle(PlainButtonStyle())
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Artist Search")
                    .font(.system(size: 18, type: .Medium))
                
                Color.clear
                    .frame(height: 0)
                    .frame(maxWidth: .infinity)
            }
            
            CaminoSearchBar(content: {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .fontWeight(.semibold)
                    TextField("Search", text: $viewModel.searchQuery)
                        .submitLabel(.done)
                        .disableAutocorrection(true)
                        .focused($isTextFieldFocused)
                        .font(.system(size: 18, type: .Regular))
                        .padding(.trailing)
                }
            })
            .padding(.top, 10)
            .padding(.bottom, 20)
            
            ScrollView(showsIndicators: false) {
                switch viewModel.artistsResponse.status {
                case .success:
                    if let artists = viewModel.artistsResponse.data?.suggestedArtists {
                        VStack(spacing: 5) {
                            ForEach(artists) { artistResult in
                                NavigationLink {
                                    ArtistView(artistID: artistResult.id)
                                        .navigationBarHidden(true)
                                }
                                label: {
                                    HStack(spacing: 15) {
                                        ImageLoader(url: artistResult.imageUrl, contentMode: .fill)
                                            .frame(width: 60, height: 60)
                                            .cornerRadius(40)
                                            .clipped()
                                        
                                        Text(artistResult.name)
                                            .font(.system(size: 20, type: .Regular))
                                            .lineLimit(2)
                                            .minimumScaleFactor(0.9)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 15))
                                            .fontWeight(.semibold)
                                            .padding(.trailing, 5)
                                    }
                                    .padding(.vertical, 5)
                                    .contentShape(Rectangle())
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .transition(.opacity)
                    }
                case .loading:
                    LoadingView()
                        .frame(height: 250)
                        .frame(maxWidth: .infinity)
                        .transition(.opacity)
                case .error:
                    ErrorView(text: "Error fetching artists", action: { await viewModel.getSuggestedArtists() })
                        .frame(height: 250)
                        .frame(maxWidth: .infinity)
                        .transition(.opacity)
                case .empty:
                    EmptyView()
                        .frame(maxWidth: .infinity)
                        .transition(.opacity)
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding([.top, .leading, .trailing], 15)
        .background(Color.background)
        .onAppear {
            isTextFieldFocused = true
        }
    }
}

#Preview {
    NavigationStack {
        ExploreSearchView()
    }
}


