//
//  Home.swift
//
//
//

import ComposableArchitecture
import Foundation
import EventKit

enum Month {
    struct State: Equatable {
        var events: [EKEvent] = []
        var month: Date
        
        var weeks: [Date] {
            guard let monthInterval = Calendar.current.dateInterval(of: .month, for: month) else { return [] }
            return Calendar.current.generateDates(
                inside: monthInterval,
                matching: DateComponents(hour: 0, minute: 0, second: 0, weekday: Calendar.current.firstWeekday)
            )
        }
        
        var localizedWeekdays: [String] {
            let weekDays = Calendar.current.shortWeekdaySymbols
            let sortedWeekDays = Array(weekDays[Calendar.current.firstWeekday - 1 ..< Calendar.current.shortWeekdaySymbols.count] + weekDays[0 ..< Calendar.current.firstWeekday - 1])
            return sortedWeekDays
        }
    }

    enum Action {
        case fetchEvents
        case fetchEventsResponse(Result<[EKEvent], EventsManagerError>)
    }

    typealias Environment = Main.Environment

    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .fetchEvents:
            return environment.eventsManager.fetchEvents(from: state.month.firstDay, to: state.month.lastDay)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(Action.fetchEventsResponse)
        case let .fetchEventsResponse(result):
            switch result {
            case .success(let events):
                state.events = events
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        return .none
    }
}

