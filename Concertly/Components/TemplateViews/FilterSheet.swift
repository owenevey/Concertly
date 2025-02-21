import SwiftUI

struct FilterSheet<T, Content: View>: View {
    
    @Binding var filter: T
    let defaultFilter: T
    let title: String
    let content: () -> Content
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 15) {
            Text(title)
                .font(.system(size: 20, type: .SemiBold))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            content()
                        
            HStack(spacing: 15) {
                ConcertlyButton(label: "Clear", style: "secondary") {
                    filter = defaultFilter
                    dismiss()
                }
                
                ConcertlyButton(label: "Done") {
                    dismiss()
                }
            }
        }
        .padding(15)
    }
}

#Preview {
    VStack {
        FilterRating(ratingFilter: .constant(3))
    }
    .background(Color.background)
    .border(Color.red)
}
