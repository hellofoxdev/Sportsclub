//
//  DashboardView.swift
//  Sportsclub
//
//  Created by Sebastian Fox on 19.10.22.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var viewModel: DivisionViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    private var gridItemLayout = [
        GridItem(.flexible()),
        //        GridItem(.flexible()),
        GridItem(.flexible())]
    
    func devisionByProfileId() -> [Division]{
        return viewModel.divisions.filter { $0.members.contains(profileViewModel.loggedProfileId) }
    }
    
    var body: some View {
        ZStack() {
//            dynamicColorGradientTLBT(colors: [.blue, .purple])
//                .edgesIgnoringSafeArea(.all)
//                .blur(radius: 3)
            
            ScrollView() {
                Rectangle().fill(.clear).frame(height: 80)
                if devisionByProfileId().count == 0 {
                    Text("Keine Sparten gefunden")
                } else {
                    
                    
                    HStack() {
                        Text("Hallennutzung mit meiner Sparte")
                            .font(.system(size: 18, weight: .bold))
                            .padding()
                        Spacer()
                    }
                    .padding(.top)
                    
                    HStack(){
                        RoundedRectangle(cornerRadius: 15).fill(.gray.opacity(0.1)).frame(height: 180)
                            .overlay(
                                VStack() {
                                    
                                    Image(systemName: "house")
                                        .font(.system(size: 22, weight: .medium))
                                        .frame(width: 22, height: 22)
                                    
                                    Text("Hallenzeit erfassen für")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(Color("darkGray"))
                                        .lineLimit(1)
                                        .padding(.bottom)
                                    Text("Quidditch")
                                        .font(.system(size: 26, weight: .bold))
                                        .foregroundColor(Color("darkGray"))
                                        .lineLimit(1)
                                    
                                }
                            )
                    }
                    .padding(.horizontal)
                    
                    HStack() {
                        Text("Meine Sparten")
                            .font(.system(size: 18, weight: .bold))
                            .padding()
                        Spacer()
                    }
                    .padding(.top)
                    
                    LazyVGrid(columns: gridItemLayout, spacing: 20) {
                        ForEach(devisionByProfileId(), id: \.self) { division in
                            HStack(){
                                RoundedRectangle(cornerRadius: 15).fill(.gray.opacity(0.1)).frame(height: 210)
                                    .overlay(
                                        VStack() {
                                            Spacer()
                                            
                                            Image(systemName: "star")
                                                .font(.system(size: 26, weight: .medium))
                                                .frame(width: 22, height: 22)
                                            
                                            Text(division.name)
                                                .font(.system(size: 26, weight: .bold))
                                                .foregroundColor(Color("darkGray"))
                                                .lineLimit(1)
                                                .padding(.horizontal)
                                            Spacer()
                                            Text("Nächstes Training")
                                                .font(.system(size: 16, weight: .bold))
                                                .foregroundColor(Color("darkGray"))
                                                .lineLimit(1)
                                            
                                            Text("Montag, 15:00 Uhr")
                                                .font(.system(size: 16, weight: .medium))
                                                .foregroundColor(Color("darkGray"))
                                                .lineLimit(1)
                                                .padding(.bottom)
                                        }
                                    )
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .edgesIgnoringSafeArea(.all)
            .onAppear(){
                viewModel.fetchAllDivisions({ (success, logMessage) -> Void in
                    if success {
                        print(logMessage)
                        
                    } else {
                        print(logMessage)
                    }
                })
            }
        }
    }
    
}

func dynamicColorGradient(colors: [Color]) -> LinearGradient {
    return LinearGradient(
        gradient: Gradient(
            colors: colors),
        startPoint: .top,
        endPoint: .bottom)
}

func dynamicColorGradientTLBT(colors: [Color]) -> LinearGradient {
    return LinearGradient(
        gradient: Gradient(
            colors: colors),
        startPoint: .topLeading,
        endPoint: .bottomTrailing)
}
