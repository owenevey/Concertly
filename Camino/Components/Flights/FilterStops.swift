import SwiftUI

struct FilterStops: View {
    
    @Binding var stopsFilter: FilterStopsEnum
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        FilterSheet(filter: $stopsFilter, title: "Stops") {
            ScrollView(showsIndicators: false) {
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
                                    .font(.system(size: 16, type: .Regular))
                                
                                Spacer()
                            }
                            .padding(.vertical, 2)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        if index < FilterStopsEnum.allCases.count - 1 {
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
    
    
    
}

#Preview {
    VStack {
        FilterStops(stopsFilter: .constant(.any))
    }
    .background(Color.background)
    .border(Color.red)
    .frame(maxHeight: 400)
}
