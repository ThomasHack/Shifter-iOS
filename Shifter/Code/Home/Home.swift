//
//  Home.swift
//  
//
//

import ComposableArchitecture
import Foundation
import EventKit

struct Day: Hashable {
    var dayDate: Int
    var startDate: Date
    var endDate: Date
    var events: [EKEvent]
}

enum Home {
    struct State: Equatable {
        var selectedMonth: Int = 9
        var events: [EKEvent] = []
        var showCreateShiftModal = false
        
        var selectedMonthReadable: String {
            let date = Calendar.current.date(from: DateComponents(year: Date().currentYear, month: selectedMonth, day: 1))!
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM"
            return formatter.string(from: date)
        }

        var days: [Day] {
            let dateComponents = DateComponents(year: Date().currentYear, month: selectedMonth)
            let calendar = Calendar.current
            let date = calendar.date(from: dateComponents)!
            let range = calendar.range(of: .day, in: .month, for: date)!

            return range.map { day in
                let date = calendar.date(from: DateComponents(year: Date().currentYear, month: selectedMonth, day: day))!
                let currentEvents = events.filter { event in
                    let eventStartDay = event.startDate.get(.day)
                    let eventEndDay = event.endDate.get(.day)
                    return day == eventStartDay || day == eventEndDay
                }
                return Day(dayDate: day, startDate: date, endDate: date.endTime, events: currentEvents)
            }
        }
    }

    enum Action {
        case previousMonth
        case nextMonth
        case fetchEvents
        case fetchEventsResponse(Result<[EKEvent], EventsManagerError>)
        case toggleCreateShiftModal(toggle: Bool)
    }

    typealias Environment = Main.Environment

    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .fetchEvents:
            let date = Calendar.current.date(from: DateComponents(year: Date().currentYear, month: state.selectedMonth, day: 1))!
            let from = date.firstDay
            let to = date.lastDay
            return environment.eventsManager.fetchEvents(from: from, to: to)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(Action.fetchEventsResponse)
            
        case .fetchEventsResponse(let result):
            switch result {
            case .success(let events):
                state.events = events
            case .failure(let error):
                print(error.localizedDescription)
            }
            return .none
            
        case .previousMonth:
            state.selectedMonth -= 1
            return Effect(value: .fetchEvents)

        case .nextMonth:
            state.selectedMonth += 1
            return Effect(value: .fetchEvents)
            
        case .toggleCreateShiftModal(toggle: let toggle):
            state.showCreateShiftModal = toggle
            return .none
        }
    }

    static let initialState = State()

    static let previewState = State()

    static let previewStore = Store(
        initialState: Home.previewState,
        reducer: Home.reducer,
        environment: Main.initialEnvironment
    )
}
