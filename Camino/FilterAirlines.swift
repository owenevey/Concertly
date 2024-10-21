import SwiftUI

struct FilterAirlines: View {
    
    @Binding var airlines: [String: (imageURL: String, isEnabled: Bool)]
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            ForEach(Array(airlines.keys), id: \.self) { airline in
                Button(action: {
                    airlines[airline]?.isEnabled.toggle()
                }) {
                    HStack {
                        Circle()
                            .fill(.white)
                            .frame(width: 40, height: 40)
//                            .overlay(
//                                AsyncImage(url: URL(string: airlines[airline]?.imageURL ?? "") { image in
//                                    image
//                                        .resizable()
//                                } placeholder: {
//                                    Image(systemName: "photo.fill")
//                                }
//                                    .scaledToFit()
//                                    .frame(width: 20, height: 20)
//                                          )
//                            )
                        Text(airline)
                        Spacer()
                        if airlines[airline]?.isEnabled == true {
                            Text("Enabled")
                                .foregroundColor(.green)
                        } else {
                            Text("Disabled")
                                .foregroundColor(.red)
                        }
                    }
                }
                .padding()
            }
        }
        
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
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    
    
}

#Preview {
    FilterAirlines(airlines: .constant([
        "American": (imageURL: "https://www.gstatic.com/flights/airline_logos/70px/AA.png", isEnabled: true),
        "Frontier": (imageURL: "https://www.gstatic.com/flights/airline_logos/70px/F9.png", isEnabled: false),
        "Alaska": (imageURL: "https://www.gstatic.com/flights/airline_logos/70px/DL.png", isEnabled: true)
    ]))
}
