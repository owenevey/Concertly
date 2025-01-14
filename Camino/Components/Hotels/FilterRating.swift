import SwiftUI

struct FilterRating: View {
    
    @Binding var ratingFilter: Int
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        FilterSheet(filter: $ratingFilter, defaultFilter: 1, title: "Minimum Rating") {
            VStack(spacing: 10) {
                ForEach((1...5).reversed(), id: \.self) { number in
                    Button(action: {
                        ratingFilter = number
                    }) {
                        HStack(spacing: 10) {
                            Image(systemName: ratingFilter == number ? "checkmark.circle.fill" : "circle")
                                .font(.system(size: 25))
                                .foregroundStyle(.accent)
                            
                            HStack {
                                ForEach(1...number, id: \.self) { _ in
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                        .font(.system(size: 18))
                                }
                            }
                            
                            Spacer()
                        }
                        .padding(.vertical, 2)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    if number > 1 {
                        Divider()
                            .frame(height: 1)
                            .overlay(.gray2)
                    }
                }
            }
            .padding(.vertical, 10)
        }
    }
    
    
    
}

#Preview {
    VStack {
        FilterRating(ratingFilter: .constant(3))
    }
    .background(Color.background)
    .border(Color.red)
}
