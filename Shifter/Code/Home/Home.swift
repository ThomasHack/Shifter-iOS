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
        case toggleCreateShiftModal(toggle: Bool)

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

            case .toggleCreateShiftModal(toggle: let toggle):
                state.showCreateShiftModal = toggle
                return .none

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

