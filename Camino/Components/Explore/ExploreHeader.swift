import SwiftUI

struct ExploreHeader: View {
    
    var body: some View {
        
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("Camino")
                    .font(.system(size: 23, type: .SemiBold))
                    .foregroundStyle(.accent)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 25) {
                    NavigationLink {
                        ExploreSearchView()
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    NavigationLink {
                        ExploreSearchView()
                    } label: {
                        Image(systemName: "bell")
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .font(.system(size: 20))
                .fontWeight(.semibold)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
            .background(Color.background)
            
            Divider()
                .frame(height: 1)
                .overlay(.gray2)
        }
        
    }
}

#Preview {
    NavigationStack {
        VStack {
            Spacer()
            ExploreHeader()
            Spacer()
        }
        .background(.green)
    }
}
