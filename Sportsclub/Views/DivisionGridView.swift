//
//  DivisionGridView.swift
//  Sportsclub
//
//  Created by Sebastian Fox on 19.10.22.
//

import SwiftUI

struct DivisionGridView: View {
    @EnvironmentObject var viewModel: DivisionViewModel
    
    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    func devisionByType(type: DivisionType) -> [Division]{
        return viewModel.divisions.filter { $0.divisionType == type }
    }
    
    var body: some View {
        ScrollView() {
        
            if viewModel.divisions.count == 0 {
                Text("Keine Sparten gefunden")
            } else {
                
                HStack() {
                    Text("Kinder")
                        .font(.system(size: 18, weight: .bold))
                        .padding()
                    Spacer()
                }
                .padding(.top)
                
                LazyVGrid(columns: gridItemLayout, spacing: 20) {
                    ForEach(devisionByType(type: .kids), id: \.self) { division in
                        VStack(){
                            RoundedRectangle(cornerRadius: 15).fill(.gray.opacity(0.1)).frame(height: 180)
                                .overlay(
                                    Text(division.name)
                                        .font(.system(size: 26, weight: .bold))
                                        .foregroundColor(Color("darkGray"))
                                        .lineLimit(1)
                                        .padding()
                                )
                        }
                    }
                }
                .padding(.horizontal)
                
//                Rectangle().fill(.clear).frame(height: 20)
                
                HStack() {
                    Text("Erwachsene")
                        .font(.system(size: 18, weight: .bold))
                        .padding()
                    Spacer()
                }
                .padding(.top)
                
                LazyVGrid(columns: gridItemLayout, spacing: 20) {
                    ForEach(devisionByType(type: .adults), id: \.self) { division in
                        VStack(){
                            RoundedRectangle(cornerRadius: 15).fill(.gray.opacity(0.1)).frame(height: 180)
                                .overlay(
                                    Text(division.name)
                                        .font(.system(size: 26, weight: .bold))
                                        .foregroundColor(Color("darkGray"))
                                        .lineLimit(1)
                                        .padding()
                                )
                            
//                            if division.days.count > 0 {
//                                Text("\(Date.today().next(division.days[0]))")
//                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
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
