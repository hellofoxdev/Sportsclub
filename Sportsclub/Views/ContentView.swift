//
//  ContentView.swift
//  Sportsclub
//
//  Created by Sebastian Fox on 30.09.22.
//

import SwiftUI
import CoreData
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift


var bounds = UIScreen.main.bounds

struct ContentView: View {
    @StateObject var viewModel = LoginViewModel()
    @StateObject var profileViewModel = ProfileViewModel()
    @EnvironmentObject var authenticationService: AuthenticationService
    
    @State var showMenu = false
    
    private func signOut() {
        viewModel.signOut()
    }
    
    private func createUser() {
        
    }
    
    
    var body: some View {
        
        NavigationView() {
            VStack() {
                if Auth.auth().currentUser == nil {
                    ZStack() {
                        BackgroundView(showMenu: $showMenu)
                            .edgesIgnoringSafeArea(.all)
                        VStack() {
                            Spacer()
                            LoginView(showMenu: $showMenu)
                                .offset(y: showMenu ? 30 : 600)
                        }
                    }
                    
                } else {
                    MainView()
                }
            }
            .onAppear {
                viewModel.connect(authenticationService: authenticationService)
                profileViewModel.connect(authenticationService: authenticationService)
            }
            .toolbar {
                
                if Auth.auth().currentUser == nil {
                    //                    NavigationLink(destination: LoginView()) {
                    //                        Text("Log-In")
                    //                            .font(.system(size: 23))
                    //                            .fontWeight(.bold)
                    //                            .foregroundColor(.primary)
                    //                    }
                } else {
                    HStack() {
                        Text("Hi, \(profileViewModel.loggedProfileName)")
                            .font(.system(size: 23))
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        NavigationLink(destination: ProfileView(uid: Auth.auth().currentUser!.uid)) {
                            Image(systemName: "person.crop.circle")
                                .font(.system(size: 21))
                                .background(Color.clear)
                                .foregroundColor(Color.black)
                            // .foregroundColor(.white)
                        }
                        
                        
                    }
                }
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
