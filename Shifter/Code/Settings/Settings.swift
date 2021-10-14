//
//  Settings.swift
//
//
//

import ComposableArchitecture
import Foundation
import EventKit

enum Settings {
    struct State: Equatable {
        var inc = 1
    }

    enum Action {
        case requestAccess
        case getAuthorizationStatus
        case fetchCalendars
        case selectCalendar(EKCalendar)
        case deleteTemplate(ShiftTemplate)
        case test

        case events(Events.Action)
        case shared(Shared.Action)
    }

    typealias Environment = Main.Environment

    static let reducer = Reducer<FeatureState, Action, Environment>.combine(
        Reducer { state, action, environment in
            switch action {
            case .requestAccess:
                return Effect(value: .events(.requestAccess))

            case .getAuthorizationStatus:
                return Effect(value: .events(.getAuthorizationStatus))

            case .fetchCalendars:
                return Effect(value: .events(.fetchCalendars))

            case .selectCalendar(let calendar):
                return Effect(value: .shared(.selectCalendar(calendar.calendarIdentifier)))

            case .deleteTemplate(let template):
                return Effect(value: .shared(.deleteShiftTemplate(template)))

            case .events, .shared:
                break

            case .test:
                let title = "Test #\(state.inc)"
                state.inc += 1
                return Effect(value: .shared(.saveShifTemplate(
                    ShiftTemplate(
                        title: title,
                        startTime: Time(hours: 1, minutes: 0),
                        endTime: Time(hours: 2, minutes: 0)
                    )
                )))
            }
            return .none
        },
        Events.reducer.pullback(
            state: \FeatureState.events,
            action: /Action.events,
            environment: { $0 }
        ),
        Shared.reducer.pullback(
            state: \FeatureState.shared,
            action: /Action.shared,
            environment: { $0 }
        )
    )

    static let initialState = State()

    static let previewState = State()
}
