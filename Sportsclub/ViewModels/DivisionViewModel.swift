//
//  Division.swift
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

class DivisionViewModel: ObservableObject {
    
    @Published var divisions = [Division]()
    
    // MARK: - Private attributes
    private var db = Firestore.firestore()
    
    func fetchAllDivisions(_ completion: @escaping (Bool, String) ->Void) {
        self.divisions = []
        db.collection("divisions").addSnapshotListener { (querySnapshot, error) in
            
            if error != nil {
                completion(false, "\(error!.localizedDescription)")
            }
            // Get Snapshot
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.divisions = documents.map { queryDocumentSnapshot -> Division in
                var tmpDivision = Division.empty
                do {
                    tmpDivision =  try queryDocumentSnapshot.data(as: Division.self)
                } catch {
                    print("puh")
                }
                return tmpDivision
            }
            completion(true, "\(self.divisions.count) divisions found")
        }
    }
    
}
