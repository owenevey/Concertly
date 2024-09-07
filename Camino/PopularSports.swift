//
//  PopularSports.swift
//  Camino
//
//  Created by Owen Evey on 9/7/24.
//

import SwiftUI

struct PopularSports: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Popular Sports")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding([.leading, .top, .trailing], 15)
            
            ScrollView(.horizontal, showsIndicators: false){
                HStack(spacing: 15){
                    
                    ForEach(suggestedPlaces.reversed(), id: \.id) { place in
                        GameCard()
                    }
                    
                }
                .padding(15)
            }
        }
    }
}

#Preview {
    PopularSports()
}
