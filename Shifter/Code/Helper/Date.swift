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
        Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }

    var lastDay: Date {
        Calendar.current.date(byAdding: DateComponents(month: 1, day: 0), to: self.firstDay)!
    }

    var startTime: Date {
        Calendar.current.startOfDay(for: self)
    }

    var endTime: Date {
        Calendar.current.date(byAdding: DateComponents(day: 1, second: -1), to: self.startTime)!
    }
    
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
