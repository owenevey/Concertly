import SwiftUI

struct ExploreHeader: View {
    
    @State private var textInput = ""
    
    var body: some View {
        Image(.goldenGate)
            .resizable()
            .scaledToFill()
//            .frame(height: 300)
            .containerRelativeFrame(.horizontal) { size, axis in
                size
            }
//            .clipped()
//            .overlay(
//                VStack {
//                    HStack {
//                        Spacer()
//                        Circle()
//                            .fill(.card)
//                            .frame(width: 40, height: 40)
//                            .overlay(
//                                Image(systemName: "bell.fill")
//                                    .foregroundStyle(.accent)
//                            )
//                            .padding(.trailing, 20)
//                            .padding(.top, 50)
//                    }
//                    
//                    Spacer()
//                    
//                    VStack {
//                        HStack {
//                            Text("What adventures\nawait?")
//                                .font(Font.custom("Barlow-Bold", size: 30))
//                                .foregroundStyle(.white)
//                                .frame(alignment: .leading)
//                                .shadow(color: .black.opacity(0.6), radius: 3)
//                            Spacer()
//                        }
//                        
//                        RoundedRectangle(cornerRadius: 20)
//                            .fill(.card)
//                            .frame(maxWidth: .infinity)
//                            .frame(height: 50)
//                            .overlay(
//                                HStack {
//                                    Image(systemName: "magnifyingglass")
//                                    TextField("Search", text: $textInput)
//                                        .font(Font.custom("Barlow-Regular", size: 18))
//                                        .padding(.trailing)
//                                }.padding()
//                            )
//                    }
//                    .padding(20)
//                }
//            )
    }
}

#Preview {
    ExploreHeader()
}
