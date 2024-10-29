import SwiftUI

struct FilterAirlines: View {
    
    @Binding var airlines: [String: (imageURL: String, isEnabled: Bool)]
    
    private var allSelected: Bool {
        airlines.values.allSatisfy { $0.isEnabled }
    }
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("Airlines")
                .font(Font.custom("Barlow-SemiBold", size: 20))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 0) {
                Button(action: {
                    let newValue = !allSelected
                    airlines = airlines.mapValues { (imageURL, _) in
                        (imageURL, newValue)
                    }
                }) {
                    HStack(spacing: 10) {
                        Image(systemName: allSelected ? "checkmark.square.fill" : "square")
                            .font(.system(size: 25))
                            .foregroundStyle(.accent)
                        
                        Text("Select all")
                            .font(Font.custom("Barlow-SemiBold", size: 16))
                        
                        Spacer()
                    }
                    .padding(.vertical, 2)
                    .contentShape(Rectangle())
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
                                HStack(spacing: 10) {
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
                                .padding(.vertical, 2)
                                .contentShape(Rectangle())
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
                
                
            }
            
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
        FilterAirlines(airlines: .constant([
            "American": (imageURL: "https://www.gstatic.com/flights/airline_logos/70px/AA.png", isEnabled: true),
            "Frontier": (imageURL: "https://www.gstatic.com/flights/airline_logos/70px/F9.png", isEnabled: false),
            "Alaska": (imageURL: "https://www.gstatic.com/flights/airline_logos/70px/DL.png", isEnabled: true)
        ]))
    }
    .background(Color("Background"))
    .border(Color.red)
    .frame(maxHeight: 400)
}
