//
//  Date.swift
//
//
//

import Foundation

extension Date {
    var currentYear: Int {
        Calendar.current.component(.year, from: self)
    }

    var firstDay: Date {
        Calendar.current.dateComponents([.calendar, .year, .month], from: self).date!
    }

    var lastDay: Date {
        Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.firstDay)!
    }

    var startTime: Date {
        Calendar.current.startOfDay(for: self)
    }

    var endTime: Date {
        Calendar.current.date(byAdding: DateComponents(day: 1, second: -1), to: self.startTime)!
    }
}
