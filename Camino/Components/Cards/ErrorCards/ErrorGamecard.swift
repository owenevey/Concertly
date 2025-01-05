import SwiftUI

struct ErrorGameCard: View {
    @Environment(\.colorScheme) var colorScheme    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack {
                Circle()
                    .fill(.accent)
                    .frame(width: 35, height: 35)
                
                StillShimmerView()
                    .frame(width: 50, height: 25)
                    .cornerRadius(5)
            }
            
            HStack {
                VStack {
                    StillShimmerView()
                        .frame(width: 50, height: 50)
                        .cornerRadius(25)
                    StillShimmerView()
                        .frame(width: 90, height: 20)
                        .cornerRadius(5)
                }
                .frame(maxWidth: .infinity)
                
                Text("vs")
                    .font(.system(size: 18, type: .Medium))
                
                VStack {
                    StillShimmerView()
                        .frame(width: 50, height: 50)
                        .cornerRadius(25)
                    
                    StillShimmerView()
                        .frame(width: 90, height: 20)
                        .cornerRadius(5)
                    
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            
            
            HStack(spacing: 20) {
                StillShimmerView()
                    .frame(width: 100, height: 20)
                    .cornerRadius(5)
                
                StillShimmerView()
                    .frame(width: 100, height: 20)
                    .cornerRadius(5)
                
            }
            .frame(maxWidth: .infinity)
            
            
        }
        .frame(maxWidth: .infinity)
        .padding(15)
        .frame(width: 300)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .background(
            Image(colorScheme == .light ? "gradientLight" : "gradientDark")
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 20))
            
            
        )
    }
}


#Preview {
    NavigationStack {
        ErrorGameCard()
        .shadow(color: .black.opacity(0.2), radius: 5)
    }
}
