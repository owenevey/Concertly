import SwiftUI

struct ConcertlySearchBar<Content: View>: View {
    
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
    ConcertlySearchBar(content: {
        HStack {
            Image(systemName: "magnifyingglass")
                .fontWeight(.semibold)
            TextField("Search", text: .constant(""))
                .font(.system(size: 17, weight: .regular))
                .padding(.trailing)
        }
    })
    .padding()
}
