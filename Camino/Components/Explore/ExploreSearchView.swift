import SwiftUI

struct ExploreSearchView: View {
    
    @Environment(\.dismiss) var dismiss
    @FocusState private var isTextFieldFocused: Bool
    @StateObject private var viewModel = ExploreSearchViewModel()
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Button {
                    dismiss()
                }
                label: {
                    Image(systemName: "arrow.backward")
                        .fontWeight(.semibold)
                        .padding(10)
                }
                .buttonStyle(PlainButtonStyle())
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Artist Search")
                    .font(.system(size: 18, type: .Medium))
                
                Color.clear
                    .frame(height: 0)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 15)
            
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
            .padding(.horizontal, 15)
            
            ScrollView {
                VStack(spacing: 0) {
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
                                            AsyncImage(url: URL(string: artistResult.imageUrl)) { image in
                                                image
                                                    .resizable()
                                            } placeholder: {
                                                Color.foreground
                                            }
                                            .scaledToFill()
                                            .frame(width: 60, height: 60)
                                            .cornerRadius(40)
                                            .clipped()
                                            
                                            Text(artistResult.name)
                                                .font(.system(size: 20, type: .Regular))
                                                .lineLimit(2)
                                                .minimumScaleFactor(0.75)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            Image(systemName: "chevron.right")
                                                .font(.system(size: 15))
                                                .fontWeight(.semibold)
                                                .padding(.trailing, 5)
                                        }
                                        .padding(.vertical, 5)
                                        .padding(.horizontal, 15)
                                        .contentShape(Rectangle())
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.bottom, 15)
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
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
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


