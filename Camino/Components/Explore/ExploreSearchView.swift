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
                        .fontWeight(.semibold)
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
            .padding(.top)
            .padding(.bottom, 20)
            
            
            
            
            switch viewModel.artistsResponse.status {
            case .success:
                if let artists = viewModel.artistsResponse.data?.suggestedArtists {
                    
                    VStack(spacing: 15) {
                        ForEach(artists) { artistResult in
                            NavigationLink {
                                ArtistView(artist: artistResult)
                                    .navigationBarHidden(true)
//                                    .navigationTransition(.zoom(sourceID: id, in: namespace))
                            }
                            label: {
                                HStack(spacing: 15) {
                                    AsyncImage(url: URL(string: artistResult.imageUrl)) { image in
                                        image
                                            .resizable()
                                    } placeholder: {
                                        Color.foreground
                                            .frame(width: 150, height: 75)
                                            .cornerRadius(10)
                                    }
                                    .scaledToFill()
                                    .frame(width: 150, height: 75)
                                    .cornerRadius(10)
                                    .clipped()
                                    
                                    Text(artistResult.name)
                                        .font(.system(size: 20, type: .Medium))
                                        .lineLimit(2)
                                        .minimumScaleFactor(0.75)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 15))
                                        .fontWeight(.semibold)
                                        .padding(.trailing, 5)
                                    
                                }
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .transition(.opacity)
                }
            case .loading:
                LoadingView()
                    .frame(height: 250)
                    .transition(.opacity)
            case .error:
                ErrorView(text: "Error fetching artists", action: { await viewModel.getSuggestedArtists() })
                    .frame(height: 250)
                    .transition(.opacity)
            default:
                EmptyView()
                    .transition(.opacity)
            }
            Spacer()
        }
        .padding(15)
        .background(Color.background)
        .onAppear {
            isTextFieldFocused = true
        }
    }
}

#Preview {
    ExploreSearchView()
}


