import SwiftUI

struct FilterSheet<T, Content: View>: View {
    
    @Binding var filter: T
    let title: String
    let content: () -> Content
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text(title)
                .font(.system(size: 20, type: .SemiBold))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            content()
            
            Spacer()
            
            CaminoButton(label: "Done") {
                dismiss()
            }
            .padding(.top)
        }
        .padding(15)
    }
    
    
    
}

//#Preview {
//    VStack {
//        FilterSheet(stopsFilter: .constant(.any))
//    }
//    .background(Color.background)
//    .border(Color.red)
//    .frame(maxHeight: 400)
//}
