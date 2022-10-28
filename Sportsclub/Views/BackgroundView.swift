//
//  BackgroundView.swift
//  Sportsclub
//
//  Created by Sebastian Fox on 25.10.22.
//

import SwiftUI

struct BackgroundView: View {
    
    @Binding var showMenu: Bool
    
    var body: some View {
        ZStack() {
//            Color.red
            
            GeometryReader{ geo -> AnyView in
                return AnyView(
                PlayerView()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geo.size.width, height: geo.size.height+100)
                        .edgesIgnoringSafeArea(.all)
                        .overlay(Color.black.opacity(0.2))
                        .blur(radius: 1)
                        .edgesIgnoringSafeArea(.all)
                )
            }
            HStack(){
                Spacer()
                VStack() {
                    Spacer()
                    Image("logo_white")
                            .resizable()
                            .frame(width: 100, height: 100)
                    
                        Text("MTV Ellerhoop")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.linear(duration: 0.2)) {
                            self.showMenu.toggle()
                        }
                    }) {
                        Text("Los geht's!")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .clipShape(Capsule())
                    }
                    .padding(.bottom, 30)
                }
                Spacer()
            }
            .padding()
        }
    }
}

