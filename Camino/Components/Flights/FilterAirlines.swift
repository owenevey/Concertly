import SwiftUI

struct FilterAirlines: View {
    
    @Binding var airlines: [String: (imageURL: String, isEnabled: Bool)]
    
    private var allSelected: Bool {
        airlines.values.allSatisfy { $0.isEnabled }
    }
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        FilterSheet(filter: $airlines, title: "Airlines") {
            VStack(spacing: 0) {
                Button(action: {
                    let newValue = !allSelected
                    airlines = airlines.mapValues { (imageURL, _) in
                        (imageURL, newValue)
                    }
                }) {
                    HStack(spacing: 10) {
                        Image(systemName: allSelected ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 25))
                            .foregroundStyle(.accent)
                        
                        Text("Select all")
                            .font(.system(size: 16, type: .Regular))
                        
                        Spacer()
                    }
                    .padding(.vertical, 2)
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.vertical, 10)
                
                Divider()
                    .frame(height: 1)
                    .overlay(.gray2)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 10) {
                        ForEach(Array(airlines.keys).indices, id: \.self) { index in
                            let airline = Array(airlines.keys)[index]
                            
                            Button(action: {
                                airlines[airline]?.isEnabled.toggle()
                            }) {
                                HStack(spacing: 10) {
                                    Image(systemName: airlines[airline]?.isEnabled ?? false ? "checkmark.circle.fill" : "circle")
                                        .font(.system(size: 25))
                                        .foregroundStyle(.accent)
                                    
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 35, height: 35)
                                        .overlay(
                                            ImageLoader(url: airlines[airline]!.imageURL, contentMode: .fit)
                                                .frame(width: 20, height: 20)
                                        )
                                    
                                    Text(airline)
                                        .font(.system(size: 16, type: .Regular))
                                    
                                    Spacer()
                                }
                                .padding(.vertical, 2)
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            if index < airlines.keys.count - 1 {
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
    
    
    
}

#Preview {
    VStack {
        FilterAirlines(airlines: .constant([
            "American": (imageURL: "https://www.gstatic.com/flights/airline_logos/70px/AA.png", isEnabled: true),
            "Frontier": (imageURL: "https://www.gstatic.com/flights/airline_logos/70px/F9.png", isEnabled: false),
            "Alaska": (imageURL: "https://www.gstatic.com/flights/airline_logos/70px/DL.png", isEnabled: true)
        ]))
    }
    .background(Color.background)
    .border(Color.red)
    .frame(maxHeight: 400)
}
