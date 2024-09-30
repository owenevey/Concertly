//
//  ExploreHeader.swift
//  Camino
//
//  Created by Owen Evey on 9/7/24.
//

import SwiftUI

struct ExploreHeader: View {
    
    @State private var textInput = ""
    
    var body: some View {
        Image(.goldenGate)
            .resizable()
            .scaledToFill()
            .frame(height: 300)
            .containerRelativeFrame(.horizontal) { size, axis in
                size - 20
            }
            .cornerRadius(25)
            .clipped()
            .overlay(
                VStack{
                    Spacer()
                    
                    VStack {
                        HStack {
                            Text("What adventures\nawait?")
                                .font(Font.custom("Barlow-ExtraBold", size: 30))
                                .foregroundStyle(.white)
                                .frame(alignment: .topLeading)
                                .shadow(radius: 5)
                            Spacer()
                        }
                        
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.card)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .overlay(
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                    TextField("Search Destination", text: $textInput)
                                        .padding(.trailing)
                                }.padding()
                            )
                    }
                    .padding(20)
                    
                    
                }
            )
    }
}

#Preview {
    ExploreHeader()
}
