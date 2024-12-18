import SwiftUI

struct CaminoSearchBar<Content: View>: View {
    
    let content: () -> Content
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(.gray1)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .overlay(
                content()
                    .padding()
            )
    }
}

#Preview {
    CaminoSearchBar(content: {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Search", text: .constant(""))
                .font(.system(size: 18, weight: .regular))
                .padding(.trailing)
        }
    })
}
