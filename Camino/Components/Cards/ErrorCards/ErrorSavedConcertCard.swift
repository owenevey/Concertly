import SwiftUI

struct ErrorSavedConcertCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            StillShimmerView()
                .frame(width: UIScreen.main.bounds.width - 30, height: 170)
                .clipped()
            
            VStack(alignment: .leading, spacing: 5) {
                StillShimmerView()
                    .frame(width: 200, height: 24)
                    .cornerRadius(5)
                
                
                HStack {
                    StillShimmerView()
                        .frame(width: 250, height: 21)
                        .cornerRadius(5)
                }
                
                Divider()
                    .frame(height: 2)
                    .padding(.vertical, 5)
                
                HStack {
                    HStack {
                        Circle()
                            .fill(.accent)
                            .frame(width: 30, height: 30)
                            .overlay(
                                Image(systemName: "airplane")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.white)
                                    .fontWeight(.semibold)
                            )
                        HStack {
                            StillShimmerView()
                                .frame(width: 60, height: 22)
                                .cornerRadius(5)
                        }
                    }
                    
                    Spacer()
                    
                    HStack {
                        Circle()
                            .fill(.accent)
                            .frame(width: 30, height: 30)
                            .overlay(
                                Image(systemName: "bed.double.fill")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.white)
                                    .fontWeight(.semibold)
                            )
                        StillShimmerView()
                            .frame(width: 60, height: 22)
                            .cornerRadius(5)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Circle()
                            .fill(.accent)
                            .frame(width: 30, height: 30)
                            .overlay(
                                Image(systemName: "ticket.fill")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.white)
                                    .fontWeight(.semibold)
                            )
                        StillShimmerView()
                            .frame(width: 60, height: 22)
                            .cornerRadius(5)
                    }
                }
            }
            .padding(15)
        }
        .frame(width: UIScreen.main.bounds.width - 30)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.foreground)
        )
    }
}

#Preview {
    NavigationStack {
        VStack {
            Spacer()
            ErrorSavedConcertCard()
                .shadow(color: .black.opacity(0.2), radius: 5)
                .padding(15)
            Spacer()
        }
        .background(Color.background)
    }
}
