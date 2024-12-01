import SwiftUI

struct FilterStops: View {
    
    @Binding var stopsFilter: FilterStopsEnum
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("Stops")
                .font(Font.custom("Barlow-SemiBold", size: 20))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 10) {
                ForEach(FilterStopsEnum.allCases.indices, id: \.self) { index in
                    let filter = FilterStopsEnum.allCases[index]
                    
                    Button(action: {
                        stopsFilter = filter
                    }) {
                        HStack(spacing: 10) {
                            Image(systemName: stopsFilter == filter ? "checkmark.circle.fill" : "circle")
                                .font(.system(size: 25))
                                .foregroundStyle(.accent)
                            
                            Text(filter.title)
                                .font(Font.custom("Barlow-SemiBold", size: 16))
                            
                            Spacer()
                        }
                        .padding(.vertical, 2)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    if index < FilterStopsEnum.allCases.count - 1 {
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
        FilterStops(stopsFilter: .constant(.any))
    }
    .background(Color("Background"))
    .border(Color.red)
    .frame(maxHeight: 400)
}
