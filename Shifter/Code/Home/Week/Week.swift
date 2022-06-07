//
//  Home.swift
//
//
//

import ComposableArchitecture
import Foundation
import EventKit

enum Week {
    struct State: Equatable {
        var events: [EKEvent]
        
        var week: Date
        
        var days: [Date] {
            guard let weekInterval = Calendar.current.dateInterval(of: .weekOfYear, for: week) else { return [] }
            return Calendar.current.generateDates(
                inside: weekInterval,
                matching: DateComponents(hour: 0, minute: 0, second: 0)
            )
        }
    }

    enum Action {

    }

    typealias Environment = Main.Environment

    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {

        }
        return .none
    }
}

