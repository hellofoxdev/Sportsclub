//
//  MainView.swift
//  Sportsclub
//
//  Created by Sebastian Fox on 25.10.22.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Meine Übersicht", systemImage: "person")
                }
            
            MessagesListView()
                .tabItem {
                    Label("Nachrichten", systemImage: "bubble.left.and.bubble.right")
                }
            
            DivisionGridView()
                .tabItem {
                    Label("Sparten", systemImage: "square.grid.3x3")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
