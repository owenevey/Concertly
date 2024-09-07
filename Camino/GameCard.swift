//
//  GameCard.swift
//  Camino
//
//  Created by Owen Evey on 9/7/24.
//

import SwiftUI

struct GameCard: View {
    var body: some View {
        NavigationLink{
            Text("Test")}
    label: {
        
        VStack(spacing: 15) {
            
            HStack(spacing: 15) {
                VStack {
                    Image(.chelsea)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                    Text("CHE")
                        .font(.headline)
                }
                
                Text("VS")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(8)
                    .background(
                        Circle()
                            .fill(Color(red: 253 / 255, green: 117 / 255, blue: 133 / 255))
                    )
                
                VStack {
                    Image(.arsenal)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                    Text("ARS")
                        .font(.headline)
                }
            }
            
            VStack {
                Text("2:30 ET | London")
                    .font(.subheadline)
                Text("September 24")
                    .font(.subheadline)
            }
            
        }
        .cornerRadius(15)
//        .padding(15)
        .frame(width: 200, height: 200)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 252 / 255, green: 82 / 255, blue: 103 / 255))
        )
    }.buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    GameCard()
}
