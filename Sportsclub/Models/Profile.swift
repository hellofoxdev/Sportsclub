//
//  Profile.swift
//  Sportsclub
//
//  Created by Sebastian Fox on 30.09.22.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Profile: Identifiable, Codable, Hashable {
    
    @DocumentID var id: String? = ""
    var name: String
    var imageUrl: String
    var divisions: [String] = []
    var leadOfDivisions: [String] = []
    var uid: String
    
    mutating func updateProfile(profile: Profile) {
        self.name = profile.name
        self.imageUrl = profile.imageUrl
        self.divisions = profile.divisions
        self.leadOfDivisions = profile.leadOfDivisions
        self.uid = profile.uid
    }
    
    mutating func addDivision(did: String) {
        if divisions.contains(where: { $0 == did}){
            
        } else {
            self.divisions.append(did)
        }
    }
    
    mutating func removeDivision(did: String) {
        if divisions.contains(where: { $0 == did}){
            let index = divisions.firstIndex(of: did)
            divisions.remove(at: index!)
        }
    }
    
    mutating func addLeadOfDivision(did: String) {
        if leadOfDivisions.contains(where: { $0 == did}){
            
        } else {
            self.leadOfDivisions.append(did)
        }
    }
    
    func isMemeberOfDivisionByDivision(division: Division) -> Bool {
        return divisions.contains(where: { $0 == division.id})
    }
    
    func isLeadOfDivisionByDivision(division: Division) -> Bool {
        return leadOfDivisions.contains(where: { $0 == division.id})
    }
    
    func isMemeberOfDivisionByDivisionId(did: String) -> Bool {
        return divisions.contains(where: { $0 == did})
    }
    
    func isLeadOfDivisionByDivisionId(did: String) -> Bool {
        return leadOfDivisions.contains(where: { $0 == did})
    }
}

extension Profile {
    static let empty = Profile(
        name: "",
        imageUrl: "",
        divisions: [],
        leadOfDivisions: [],
        uid: ""
    )
}
