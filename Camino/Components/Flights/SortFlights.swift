import SwiftUI

struct SortFlights: View {
    
    @Binding var sortMethod: SortFlightsEnum
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        FilterSheet(filter: $sortMethod, defaultFilter: SortFlightsEnum.recommended, title: "Sort") {
            VStack(spacing: 10) {
                ForEach(SortFlightsEnum.allCases.indices, id: \.self) { index in
                    let method = SortFlightsEnum.allCases[index]
                    
                    Button(action: {
                        sortMethod = method
                    }) {
                        HStack(spacing: 10) {
                            Image(systemName: sortMethod == method ? "checkmark.circle.fill" : "circle")
                                .font(.system(size: 25))
                                .foregroundStyle(.accent)
                            
                            Text(method.title)
                                .font(.system(size: 17, type: .Regular))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 2)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    if index < SortFlightsEnum.allCases.count - 1 {
                        Divider()
                            .frame(height: 1)
                            .overlay(.gray2)
                    }
                }
            }
        }
    }
}

#Preview {
    VStack {
        SortFlights(sortMethod: .constant(.cheapest))
    }
    .background(Color.background)
    .border(Color.red)
}
