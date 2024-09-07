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
            .frame(height: 350)
            .containerRelativeFrame(.horizontal) { size, axis in
                size
            }
            .clipped()
            .padding(.top, -50)
            .overlay(
                LinearGradient(colors: [Color.white.opacity(1), .clear], startPoint: .top, endPoint: UnitPoint(x: 0.5, y: 0.4))
                    .padding(.top, -50)
            )
            .overlay(
                VStack{
                    Spacer()
                    
                    VStack {
                        HStack {
                            Text("What adventures\nawait?")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .frame(alignment: .topLeading)
                                .shadow(radius: 5)
                            Spacer()
                        }
                        
                        RoundedRectangle(cornerRadius: 25)
                            .fill(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .overlay(
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                    TextField("Search Destination", text: $textInput)
                                        .padding(.trailing)
                                }.padding()
                            )
                    }.padding(20)
                    
                    
                }
            )
    }
}

#Preview {
    ExploreHeader()
}
