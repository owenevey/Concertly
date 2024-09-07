//
//  TripsView.swift
//  Camino
//
//  Created by Owen Evey on 9/6/24.
//

import SwiftUI

struct TripsView: View {
    @State private var textInput = ""
    var body: some View {
        VStack{
            Image(.venice)
                .resizable()
                .scaledToFit()
                .frame(height: 350)
                .frame(maxWidth: .infinity)
                .clipped()
                .overlay(
                    VStack{
                        HStack {
                            Spacer()
                            Button {
                                print("Notification button was tapped")
                            } label: {
                                ZStack{
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 50, height: 50)
                                    Image(systemName: "bell")
                                        .foregroundStyle(.black)
                                        .font(.system(size: 20))
                                }
                            }
                        }
                        .padding(.top, 50)
                        .padding(.horizontal, 20)
                        
                        Spacer()
                        
                        VStack {
                            HStack {
                                Text("What adventures\nawait?")
                                    .font(.largeTitle)
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
                        }.padding()
                        
                    }
                )
            
                .padding()
                .border(.green)
            Spacer()
            
        }
        .ignoresSafeArea()
    }
}

#Preview {
    TripsView()
}
