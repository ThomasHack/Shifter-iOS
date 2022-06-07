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
        var showSettingsModal = false
        var selectedIndex: Int = Calendar.current.component(.month, from: Date()) - 1
        
        var currentMonth: Int = {
            Calendar.current.component(.month, from: Date()) - 1
        }()
    }

    enum Action {
        case fetchEvents
        case fetchEventsForMonth(Date)
        case previousMonth
        case nextMonth
        case currentMonth
        case updateSelectedIndex(Int)
        case addShiftForDate(shift: ShiftTemplate, date: Date)
        case deleteShiftForDate(date: Date)
        case deleteShiftResponse(Result<[EKEvent], EventsManagerError>)
        case toggleSettingsModal(Bool)

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
            case .fetchEventsForMonth(let date):
                return Effect(value: .events(.fetchEvents))
            case .previousMonth:
                state.selectedIndex -= 1
                
            case .nextMonth:
                state.selectedIndex += 1
                
            case .currentMonth:
                state.selectedIndex = state.currentMonth
                
            case .updateSelectedIndex(let index):
                state.selectedIndex = index

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
                
            case .deleteShiftForDate(date: let date):
                return environment.eventsManager.fetchEvents(from: date.startTime, to: date.endTime)
                    .receive(on: environment.mainQueue)
                    .catchToEffect()
                    .map(Action.deleteShiftResponse)
                
            case .deleteShiftResponse(let result):
                switch result {
                case .success(let events):
                    guard let event = events.first, event.calendar.calendarIdentifier == state.shared.calendarId else { return .none }
                    return Effect(value: .events(.removeEvent(event)))

                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            case .toggleSettingsModal(let toggle):
                state.showSettingsModal = toggle

            case .events, .shared:
                break
            }
            return .none
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

