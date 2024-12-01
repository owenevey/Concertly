import SwiftUI

struct SortFlights: View {
    
    @Binding var sortMethod: SortFlightsEnum
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("Sort")
                .font(Font.custom("Barlow-SemiBold", size: 20))
                .frame(maxWidth: .infinity, alignment: .leading)
            
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
                                .font(Font.custom("Barlow-SemiBold", size: 16))
                            
                            Spacer()
                        }
                        .padding(.vertical, 2)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    if index < SortFlightsEnum.allCases.count - 1 {
                        Divider()
                            .frame(height: 1)
                            .overlay(.customGray)
                    }
                }
            }
            .padding(.vertical, 10)
            
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Text("Done")
                    .font(Font.custom("Barlow-SemiBold", size: 18))
                    .padding()
                    .frame(width: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.accent)
                    )
                    .padding(.top)
            }
            .buttonStyle(PlainButtonStyle())
            
        }
        .padding()
    }
    
    
    
}

#Preview {
    VStack {
        SortFlights(sortMethod: .constant(.cheapest))
    }
    .background(Color("Background"))
    .border(Color.red)
    .frame(maxHeight: 400)
}
