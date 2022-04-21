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
        var showCreateShiftModal = false
    }

    enum Action {
        case selectCalendar(EKCalendar)
        case deleteTemplate(ShiftTemplate)
        case toggleCreateShiftModal(toggle: Bool)

        case events(Events.Action)
        case shared(Shared.Action)
    }

    typealias Environment = Main.Environment

    static let reducer = Reducer<FeatureState, Action, Environment>.combine(
        Reducer { state, action, environment in
            switch action {
            case .selectCalendar(let calendar):
                return Effect(value: .shared(.selectCalendar(calendar.calendarIdentifier)))

            case .deleteTemplate(let template):
                return Effect(value: .shared(.deleteShiftTemplate(template)))
                
            case .toggleCreateShiftModal(toggle: let toggle):
                state.showCreateShiftModal = toggle
                return .none

            case .events, .shared:
                break
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
