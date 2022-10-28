//
//  ClubViewModel.swift
//  Sportsclub
//
//  Created by Sebastian Fox on 30.09.22.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class ClubViewModel: ObservableObject {
    // MARK: - Output
    @Published var club: Club
    
    init(club: Club) {
        self.club = club
    }
    
    //  init(uid: String) {
    //    self.profile = Profile.empty
    //    fetchProfile(uid)
    //  }
    
    // MARK: - Private attributes
    private var db = Firestore.firestore()
    
    func fetchAllClub() {
        db.collection("clubs")
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error getting documents: \(error)")
                }
                else {
                    if let querySnapshot = querySnapshot {
                        if let document = querySnapshot.documents.first {
                            do {
                                self.club = try document.data(as: Club.self)
                            }
                            catch {
                                
                            }
                        }
                    }
                }
            }
    }
    
    func fetchClub(cid: String) {
        
        let docRef = db.collection("clubs").document(cid)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        }
    }
}
