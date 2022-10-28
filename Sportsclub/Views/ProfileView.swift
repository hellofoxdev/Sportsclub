//
//  ProfileView.swift
//  Sportsclub
//
//  Created by Sebastian Fox on 30.09.22.
//

import SwiftUI
import Firebase

struct ProfileView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel: ProfileViewModel
    
    let testDivision = DivisionFB(did: "xxx", name: "Quidditsch", leadsIds: ["xxx"], memebersIds: ["xxx"], days: [], times: [])
    
    init() {
        self.viewModel = ProfileViewModel()
    }
    
    init(profile: Profile) {
        self.viewModel = ProfileViewModel(profile: profile)
    }
    
    init(uid: String) {
        self.viewModel = ProfileViewModel(uid: uid)
    }
    
    func removeProfile() {
        viewModel.profileId = ""
        viewModel.loggedProfileId = ""
    }
    
    func createUser() {
        let uid = Auth.auth().currentUser?.uid
        //   let testDivision2 = DivisionFB(did: "xxx", name: "Quidditsch", leadsIds: ["xxx"], memebersIds: ["xxx"])
        let profile = Profile(name: "Bastixxx", imageUrl: "xxx", divisions: [], leadOfDivisions: [], uid: uid!)
        viewModel.createProfile(profile, completion: {_,_ in })
    }
    
    func addDevision(division: DivisionFB) {
//        viewModel.profile.addDivision(did: division)
        viewModel.updateDivisions()
    }
    
    func updateDevision(division: DivisionFB) {
//        viewModel.profile.updateDivision(did: division)
        viewModel.updateDivisions()
    }
    
    func logOut() {
        viewModel.signOut()
        self.presentationMode.wrappedValue.dismiss()
        
    }
    
    var body: some View {
        VStack(){
            Form {
                Text(viewModel.profile.id ?? "oh-oh")
                Text(viewModel.profile.name)
                
                ForEach(viewModel.profile.divisions, id: \.self) { division in
                    Text(division)
                }
            
            if viewModel.profile.id == "" {
                Button(action: createUser) {
                    Text("Create Profile")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
//                else {
//
//                Button(action: removeProfile) {
//                    Text("Remove Profile")
//                        .frame(maxWidth: .infinity)
//                }
//                .buttonStyle(.borderedProminent)
//                .controlSize(.large)
//            }
            
//            Button(action: {
//                addDevision(division: testDivision)
//            }) {
//                Text("Add Divisions")
//                    .frame(maxWidth: .infinity)
//            }
//            .buttonStyle(.borderedProminent)
//            .controlSize(.large)
//
//            Button(action: {
//                updateDevision(division: testDivision)
//            }) {
//                Text("Update Divisions")
//                    .frame(maxWidth: .infinity)
//            }
//            .buttonStyle(.borderedProminent)
//            .controlSize(.large)
                
                
                Button(action: {
                    logOut()
                }) {
                    Text("Log Out")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                
                
            }
        }
    }
}

//struct ProfileView_Previews: PreviewProvider {
//  static var previews: some View {
//    ProfileView(profile: Profile(name: "fox", email: "sebastian.fox@me.com", uid: "xxx"))
//  }
//}
