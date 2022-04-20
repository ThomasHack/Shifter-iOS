//
//  Home.swift
//
//
//

import ComposableArchitecture
import Foundation
import EventKit

enum Home {

    struct State: Equatable {
        var showCreateShiftModal = false
    }

    enum Action {
        case fetchEvents
        case previousMonth
        case nextMonth
        case resetMonth
        case toggleCreateShiftModal(toggle: Bool)
        case addShiftForDate(shift: ShiftTemplate, date: Date)

        case events(Events.Action)
        case shared(Shared.Action)
    }

    typealias Environment = Main.Environment

    static let reducer = Reducer<HomeFeatureState, Action, Environment>.combine(
        Reducer { state, action, environment in
            switch action {
            case .fetchEvents:
                if let calendarId = state.shared.calendarId {
                    return Effect(value: .events(.fetchEventsForCalendar(calendarId)))
                }
                return Effect(value: .events(.fetchEvents))
            case .previousMonth:
                return Effect(value: .events(.previousMonth))

            case .nextMonth:
                return Effect(value: .events(.nextMonth))
                
            case .resetMonth:
                return Effect(value: .events(.resetMonth))

            case .toggleCreateShiftModal(toggle: let toggle):
                state.showCreateShiftModal = toggle
                return .none
                
            case .addShiftForDate(shift: let shift, date: let date):
                guard let calendarId = state.shared.calendarId else { return .none }
                var components = DateComponents()
                components.year = date.get(.year)
                components.month = date.get(.month)
                components.day = date.get(.day)
                components.hour = shift.startTime.hours
                components.minute = shift.startTime.minutes
                let startDate = Calendar.current.date(from: components)

                components.hour = shift.endTime.hours
                components.minute = shift.endTime.minutes
                if shift.endTime.hours < shift.startTime.hours {
                    components.day = components.day?.advanced(by: 1)
                }
                let endDate = Calendar.current.date(from: components)
                
                guard let startDate = startDate, let endDate = endDate else {
                    return .none
                }
                
                return Effect(value: .events(.addEvent(shift.title, startDate, endDate, calendarId)))

            case .events, .shared:
                return .none
            }
        },
        Events.reducer.pullback(
            state: \HomeFeatureState.events,
            action: /Action.events,
            environment: { $0 }
        ),
        Shared.reducer.pullback(
            state: \HomeFeatureState.shared,
            action: /Action.shared,
            environment: { $0 }
        )
    )

    static let initialState = State()

    static let previewState = State()
}

