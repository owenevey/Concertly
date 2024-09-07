//
//  PlaceCard.swift
//  Camino
//
//  Created by Owen Evey on 9/7/24.
//

import SwiftUI

struct PlaceCard: View {
    
    var place: SuggestedPlace
    var minPrice: Int?
    
    var body: some View {
        NavigationLink{
            Text("Test")}
    label: {
        
        VStack(alignment: .leading, spacing: 10) {
            Text(place.name)
                .font(.title3)
                .fontWeight(.bold)
            
            if let price = minPrice {
                Text("💸 Flights from $\(price)")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(.green)
            }
            
            Text(place.description)
                .font(.subheadline)
                .lineLimit(2, reservesSpace: true)
            
            Image(place.imageString)
                .resizable()
                .scaledToFill()
                .frame(width: 210, height: 150)
                .cornerRadius(10)
                .clipped()
            
            Text("\(place.countryFlag) \(place.country)")
            
        }
        .padding(15)
        .frame(width: 240)
        
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 242 / 255, green: 245 / 255, blue: 248 / 255))
        )
    }.buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    PlaceCard(place: suggestedPlaces[0])
}
