//
//  SportsclubApp.swift
//  Sportsclub
//
//  Created by Sebastian Fox on 30.09.22.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//    FirebaseApp.configure()
    return true
  }
}

@main
struct SportsclubApp: App {
    let persistenceController = PersistenceController.shared
    
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // ViewModels & Services
    var authenticationService: AuthenticationService
    var loginViewModel: LoginViewModel
    var profileViewModel: ProfileViewModel
    var divisionViewModel: DivisionViewModel
    
    init() {
        FirebaseApp.configure()
        authenticationService = AuthenticationService()
        loginViewModel = LoginViewModel()
        profileViewModel = ProfileViewModel()
        divisionViewModel = DivisionViewModel()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(authenticationService)
                .environmentObject(loginViewModel)
                .environmentObject(profileViewModel)
                .environmentObject(divisionViewModel)
        }
    }
}
