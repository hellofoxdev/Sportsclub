//
//  ProfileViewModel.swift
//  Sportsclub
//
//  Created by Sebastian Fox on 30.09.22.
//

import SwiftUI
import Foundation
import Combine
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class ProfileViewModel: ObservableObject {
    // MARK: - Output
    @Published var profile: Profile
    
    @Published var profiles = [Profile]()
    
    @Published var profileId: String = UserDefaults.standard.string(forKey: "profileId") ?? ""{
        didSet {
            UserDefaults.standard.set(self.profileId, forKey: "profileId")
        }
    }
    
    @Published var loggedProfileId: String = UserDefaults.standard.string(forKey: "loggedProfileId") ?? ""{
        didSet {
            UserDefaults.standard.set(self.loggedProfileId, forKey: "loggedProfileId")
        }
    }
    
    @Published var loggedProfileName: String = UserDefaults.standard.string(forKey: "loggedProfileName") ?? ""{
        didSet {
            UserDefaults.standard.set(self.loggedProfileName, forKey: "loggedProfileName")
        }
    }
    
    @Published var loggedProfileImageUrl: String = UserDefaults.standard.string(forKey: "loggedProfileImageUrl") ?? ""{
        didSet {
            UserDefaults.standard.set(self.loggedProfileImageUrl, forKey: "loggedProfileImageUrl")
        }
    }
    

    // MARK: - Output
    @Published var isValid: Bool  = false
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var errorMessage: String = ""
    @Published var user: User?
    
    // MARK: - Dependencies
    private var authenticationService: AuthenticationService?
    
    init() {
        self.profile = Profile.empty
    }
    
    init(profile: Profile) {
        self.profile = profile
    }
    
    init(uid: String) {
        self.profile = Profile.empty
        fetchProfile(uid)
//        fetchAllProfiles({ (success, message) -> Void in
//            if success {
//                print(message)
//            } else {
//                print(message)
//            }
//        })
    }
    
    func connect(authenticationService: AuthenticationService) {
      if self.authenticationService == nil {
        self.authenticationService = authenticationService
        
        self.authenticationService?
          .$authenticationState
          .assign(to: &$authenticationState)
        
        self.authenticationService?
          .$errorMessage
          .assign(to: &$errorMessage)
        
        self.authenticationService?
          .$user
          .assign(to: &$user)
        
      }
    }
    
    // MARK: - Private attributes
    private var db = Firestore.firestore()
    
    func fetchProfile(_ uid: String) {
        db.collection("profiles")
            .whereField("uid", isEqualTo: uid)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error getting documents: \(error)")
                }
                else {
                    if let querySnapshot = querySnapshot {
                        if let document = querySnapshot.documents.first {
                            do {
                                self.profile = try document.data(as: Profile.self)
                                self.loggedProfileId = self.profile.id!
                                self.loggedProfileName = self.profile.name
                                self.loggedProfileImageUrl = self.profile.imageUrl
                            }
                            catch {
                                
                            }
                        }
                    }
                }
            }
    }
    
    func fetchAllProfiles(_ completion: @escaping (Bool, String) ->Void) {
        self.profiles = []
        db.collection("profiles").addSnapshotListener { (querySnapshot, error) in

            if error != nil {
                completion(false, "\(error!.localizedDescription)")
            }
            // Get Snapshot
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

                self.profiles = documents.map { queryDocumentSnapshot -> Profile in
                    var tmpProfile = Profile.empty
                    do {
                        tmpProfile =  try queryDocumentSnapshot.data(as: Profile.self)
                    } catch {

                    }
                    return tmpProfile
                }
                completion(true, "\(self.profiles.count) users found")
            }
    }
    
    func saveChangesToProfile(updatedProfileData: Profile) {
        var copyOfProfile: Profile = self.profile
        copyOfProfile.name = updatedProfileData.name
        copyOfProfile.uid = updatedProfileData.uid
        
        let userProfile = db.collection("profiles").document(profile.id!)

        do {
            try userProfile.setData(from: copyOfProfile)
        } catch let error {
            print("Error writing city to Firestore: \(error)")
        }
    }
    
    func createProfile(_ profile: Profile, completion: @escaping (Bool, String)->Void) {
        do {
        var ref: DocumentReference? = nil
          ref = try db.collection("profiles").addDocument(from: profile) { err in
              if let err = err {
                  print("Error adding document: \(err)")
              } else {
                  print("Document added with ID: \(ref!.documentID)")
                  self.profile = profile
                  self.profile.id = ref!.documentID
                  self.profileId = ref!.documentID
              }
                completion(true, profile.name)
            }
        } catch let error {
            completion(false, "Error writing city to Firestore: \(error)")
        }
    }
    
    func addDivisionToProfile(division: Division) {
        
        var leadIds: [String] = []
        for lead in division.leads {
            leadIds.append(lead)
        }
        var memberIds: [String] = []
        for member in division.members {
            memberIds.append(member)
        }
        
//        var divisionFb: DivisionFB = DivisionFB(
//            did: division.id!,
//            name: division.name,
//            leadsIds: leadIds,
//            memebersIds: memberIds,
//            days: division.days,
//            times: division.times
//            )
        
        var copyOfProfile: Profile = self.profile
        
        copyOfProfile.addDivision(did: division.id!)
        
        let userProfile = db.collection("profiles").document(profile.id!)

        do {
            try userProfile.setData(from: copyOfProfile)
        } catch let error {
            print("Error writing city to Firestore: \(error)")
        }
        
    }
    
    func addLeadOfDivisionToProfile(division: Division) {
        
        var leadIds: [String] = []
        for lead in division.leads {
            leadIds.append(lead)
        }
        var memberIds: [String] = []
        for member in division.members {
            memberIds.append(member)
        }
        
//        var divisionFb: DivisionFB = DivisionFB(
//            did: division.id!,
//            name: division.name,
//            leadsIds: leadIds,
//            memebersIds: memberIds,
//            days: division.days,
//            times: division.times)
        
        var copyOfProfile: Profile = self.profile
        
        copyOfProfile.addLeadOfDivision(did: division.id!)
        
        let userProfile = db.collection("profiles").document(profile.id!)

        do {
            try userProfile.setData(from: copyOfProfile)
        } catch let error {
            print("Error writing city to Firestore: \(error)")
        }
        
    }
    
    func updateDivisions() {
        
        let userProfile = db.collection("profiles").document(profile.id!)

        do {
            try userProfile.setData(from: profile)
        } catch let error {
            print("Error writing city to Firestore: \(error)")
        }
    }
    
    func signOut() {
        do  {
            try Auth.auth().signOut()
            self.loggedProfileId = ""
            self.loggedProfileName = ""
            self.loggedProfileImageUrl = ""
            authenticationState = .unauthenticated
        }
        catch {
            print(error)
        }
    }
}

protocol ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable
}

extension UserDefaults: ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: forKey)
        } catch {
            throw ObjectSavableError.unableToEncode
        }
    }
    
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable {
        guard let data = data(forKey: forKey) else { throw ObjectSavableError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw ObjectSavableError.unableToDecode
        }
    }
}

enum ObjectSavableError: String, LocalizedError {
    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object found for the given key"
    case unableToDecode = "Unable to decode object into given type"
    
    var errorDescription: String? {
        rawValue
    }
}
