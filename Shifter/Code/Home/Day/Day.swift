//
//  Day.swift
//
//
//

import ComposableArchitecture
import Foundation
import EventKit

enum Day {
    struct State: Equatable {
        var events: [EKEvent] {
            didSet {
                print(events.count)
            }
        }
        
        var day: Date
        
        var isToday: Bool {
            Calendar.current.isDate(day, inSameDayAs: Date())
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
        .debug()
}

