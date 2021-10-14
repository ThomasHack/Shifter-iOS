//
//  Day.swift
//  Shifter
//
//  Created by Hack, Thomas on 14.10.21.
//

import Foundation
import EventKit

struct Day: Hashable {
    var dayDate: Int
    var startDate: Date
    var endDate: Date
    var events: [EKEvent]
}
