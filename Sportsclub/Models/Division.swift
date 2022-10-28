//
//  Division.swift
//  Sportsclub
//
//  Created by Sebastian Fox on 30.09.22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

enum DivisionType: String, CaseIterable, Identifiable, Codable {
    case adults, kids
    var id: Self { self }
}

enum Weekday: String, CaseIterable, Identifiable, Codable {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    var id: Self { self }
  }

struct Division: Identifiable, Codable, Hashable {
    
    @DocumentID var id: String? = ""
    var name: String
    var info: String
    var description: String
    var leads: [String]
    var members: [String]
    var days: [Weekday]
    var times: [String]
    var cid: String
    var divisionType: DivisionType
    
    mutating func addMember(member: String) {
        self.members.append(member)
    }
    
    mutating func addLead(lead: String) {
        self.leads.append(lead)
    }
    
    func isUserInDivisionByUser(profile: Profile) -> Bool {
        members.contains(where: { $0 == profile.id })
    }
    
    func isUserLeadOfDivisionByUser(profile: Profile) -> Bool {
        leads.contains(where: { $0 == profile.id })
    }
    
    func isUserInDivisionByUserId(pid: String) -> Bool {
        members.contains(where: { $0 == pid })
    }
    
    func isUserLeadOfDivisionByUser(pid: String) -> Bool {
        leads.contains(where: { $0 == pid })
    }
}

extension Division {
    static let empty = Division(
        name: "",
        info: "",
        description: "",
        leads: [],
        members: [],
        days: [],
        times: [],
        cid: "",
        divisionType: DivisionType.adults
    )
}

struct DivisionFB: Codable, Hashable {
    var did: String // division id
    var name: String
    var leadsIds: [String]
    var memebersIds: [String]
    var days: [String]
    var times: [String]
}

extension Date {

    static func today() -> Date {
        return Date()
    }

    func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
      return get(.next,
                 weekday,
                 considerToday: considerToday)
    }

    func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
      return get(.previous,
                 weekday,
                 considerToday: considerToday)
    }

    func get(_ direction: SearchDirection,
             _ weekDay: Weekday,
             considerToday consider: Bool = false) -> Date {

      let dayName = weekDay.rawValue

      let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }

      assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")

      let searchWeekdayIndex = weekdaysName.firstIndex(of: dayName)! + 1

      let calendar = Calendar(identifier: .gregorian)

      if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
        return self
      }

      var nextDateComponent = calendar.dateComponents([.hour, .minute, .second], from: self)
      nextDateComponent.weekday = searchWeekdayIndex

      let date = calendar.nextDate(after: self,
                                   matching: nextDateComponent,
                                   matchingPolicy: .nextTime,
                                   direction: direction.calendarSearchDirection)

      return date!
    }

  }

  // MARK: Helper methods
  extension Date {
    func getWeekDaysInEnglish() -> [String] {
      var calendar = Calendar(identifier: .gregorian)
      calendar.locale = Locale(identifier: "en_US_POSIX")
      return calendar.weekdaySymbols
    }

//      enum Weekday: String, Hashable, Codable {
//      case monday, tuesday, wednesday, thursday, friday, saturday, sunday
//    }

    enum SearchDirection {
      case next
      case previous

      var calendarSearchDirection: Calendar.SearchDirection {
        switch self {
        case .next:
          return .forward
        case .previous:
          return .backward
        }
      }
    }
  }
