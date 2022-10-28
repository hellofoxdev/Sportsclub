//
//  Cost.swift
//  Sportsclub
//
//  Created by Sebastian Fox on 09.10.22.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

enum CostType: String, CaseIterable, Identifiable, Codable {
    case headOfDivisionInvoice, boardMemberInvoice, otherInvoice
    var id: Self { self }
}

struct Cost: Identifiable, Codable {
    @DocumentID var id: String? = ""
    var amount: Double
    var costType: CostType
}
