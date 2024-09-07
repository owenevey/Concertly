//
//  ExploreView.swift
//  Camino
//
//  Created by Owen Evey on 9/5/24.
//

import SwiftUI

struct ExploreView: View {
    
    
    
    var body: some View {
        NavigationStack{
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    ExploreHeader()
                    ExplorePills()
                    SuggestedPlaces()
                    FlightDeals()
                    PopularSports()
                    Spacer()
                }.padding(.bottom, 100)
            }
            .ignoresSafeArea()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        print("Notification button was tapped")
                    } label: {
                        ZStack{
                            Circle()
                                .fill(.green)
                                .frame(width: 35, height: 35)
                            Image(systemName: "bell.fill")
                                .foregroundStyle(.white)
                                .font(.system(size: 15))
                        }
                    }
                }
            }
            .toolbarBackground(.hidden)
        }
    }
}

#Preview {
    ExploreView()
}
