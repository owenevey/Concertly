import SwiftUI

struct GeneralHeader: View {
    
    var title: String
    
    var body: some View {
        
        VStack(spacing: 0) {
            HStack(spacing: 15) {
                TranslucentBackButton()
                
                Text(title)
                    .font(.system(size: 23, type: .Medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                    .minimumScaleFactor(0.9)

            }
            .padding(.trailing, 20)
            .padding(.bottom, 5)
            .background(Color.background)
            
            Divider()
                .frame(height: 1)
                .overlay(.gray2)
        }
        
    }
}

#Preview {
    VStack {
        Spacer()
        GeneralHeader(title: "Dua Lipa")
        Spacer()
    }
    .background(Color.green)
    
}
