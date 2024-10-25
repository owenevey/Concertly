import SwiftUI

struct FilterAirlines: View {
    
    @Binding var airlines: [String: (imageURL: String, isEnabled: Bool)]
    
    @State var selectAll: Bool = true
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Airlines")
                .font(Font.custom("Barlow-SemiBold", size: 20))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Button(action: {
                selectAll.toggle()
            }) {
                HStack {
                    Image(systemName: selectAll ? "checkmark.square.fill" : "square")
                        .font(.system(size: 25))
                        .foregroundStyle(.accent)
                    
                    Text("Select all")
                        .font(Font.custom("Barlow-SemiBold", size: 16))
                    
                    Spacer()
                }
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.vertical, 10)
            
            Divider()
                .frame(height: 1)
                .overlay(.customGray)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 10) {
                    
                    
                    ForEach(Array(airlines.keys).indices, id: \.self) { index in
                        let airline = Array(airlines.keys)[index]
                        
                        Button(action: {
                            airlines[airline]?.isEnabled.toggle()
                        }) {
                            HStack {
                                Image(systemName: airlines[airline]?.isEnabled ?? false ? "checkmark.square.fill" : "square")
                                    .font(.system(size: 25))
                                    .foregroundStyle(.accent)
                                Circle()
                                    .fill(.white)
                                    .frame(width: 35, height: 35)
                                    .overlay(
                                        AsyncImage(url: URL(string: airlines[airline]!.imageURL)) { image in
                                            image
                                                .resizable()
                                        } placeholder: {
                                            Image(systemName: "photo.fill")
                                        }
                                            .scaledToFit()
                                            .frame(width: 20, height: 20)
                                    )
                                
                                Text(airline)
                                    .font(Font.custom("Barlow-SemiBold", size: 16))
                                Spacer()
                                Text("$269")
                                    .font(Font.custom("Barlow-SemiBold", size: 16))
                                    .foregroundStyle(.gray)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        if index < airlines.keys.count - 1 {
                            Divider()
                                .frame(height: 1)
                                .overlay(.customGray)
                        }
                    }
                }
                .padding(.vertical, 10)
            }
            .frame(maxHeight: 300)
            
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
        .padding()
        .background(Color("Background"))
        
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
    .border(Color.red)
    
}
