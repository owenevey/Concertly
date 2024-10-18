import SwiftUI

struct FilterAirlines: View {
    
    @Binding var airlines: [String: Bool]
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            ForEach(Array(airlines.keys), id: \.self) { airline in
                Button(action: {
                    airlines[airline]?.toggle()
                }) {
                    HStack {
                        Text(airline)
                        Spacer()
                        if airlines[airline] == true {
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
        "American": true,
        "Delta": false,
        "Alaska": true
    ]))
}
