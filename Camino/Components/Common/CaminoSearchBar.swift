import SwiftUI

struct CaminoSearchBar<Content: View>: View {
    
    let content: () -> Content
    
    var body: some View {
        content()
            .padding(.vertical, 12)
            .padding(.horizontal, 15)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(.gray1)
                    .frame(maxWidth: .infinity)
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
    .padding()
}
