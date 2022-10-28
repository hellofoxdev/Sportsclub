//
//  Club.swift
//  Sportsclub
//
//  Created by Sebastian Fox on 30.09.22.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Club: Identifiable, Codable {
  @DocumentID var id: String? = ""
  var name: String
}
