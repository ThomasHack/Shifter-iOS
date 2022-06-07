//
//  Events.swift
//  
//
//

import ComposableArchitecture
import Foundation
import EventKit

enum Events {
    struct State: Equatable {
        var calendar = Calendar.current
        var calendars: [EKCalendar] = []
        var events: [EKEvent] = []

        var selectedMonth: Date = Date()
        var selectedMonthReadable: String {
            DateFormatter.month.string(from: selectedMonth)
        }
    }

    enum Action {
        case previousMonth
        case nextMonth
        case resetMonth
        case requestAccess
        case requestAccessResponse(Result<Bool, EventsManagerError>)
        case getAuthorizationStatus
        case getAuthorizationStatusResponse(Result<Bool, EventsManagerError>)
        case fetchCalendars
        case fetchCalendarsResponse(Result<[EKCalendar], EventsManagerError>)
        case fetchEvents
        case fetchEventsForCalendar(String)
        case fetchEventsResponse(Result<[EKEvent], EventsManagerError>)
        case addEvent(String, Date, Date, String)
        case addEventResponse(Result<Bool, EventsManagerError>)
        case removeEvent(EKEvent)
        case removeEventResponse(Result<Bool, EventsManagerError>)
    }

    typealias Environment = Main.Environment

    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .previousMonth:
            if let date = Calendar.current.date(byAdding: .month, value: -1, to: state.selectedMonth) {
                state.selectedMonth = date
            }
            return Effect(value: .fetchEvents)

        case .nextMonth:
            if let date = Calendar.current.date(byAdding: .month, value: 1, to: state.selectedMonth) {
                state.selectedMonth = date
            }
            return Effect(value: .fetchEvents)
            
        case .resetMonth:
            state.selectedMonth = Date()
            return Effect(value: .fetchEvents)

        case .requestAccess:
            return environment.eventsManager.requestAccess()
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(Action.requestAccessResponse)

        case .requestAccessResponse(let result):
            switch result {
            case .success:
                return Effect(value: .fetchCalendars)
            case .failure(let error):
                print(error.localizedDescription)
            }
            return .none

        case .getAuthorizationStatus:
            return environment.eventsManager.getStatus()
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(Action.getAuthorizationStatusResponse)

        case .getAuthorizationStatusResponse(let result):
            switch result {
            case .success:
                return Effect(value: .fetchCalendars)
            case .failure(let error):
                switch error {
                case .denied:
                    print("denied")
                case .noAccess:
                    print("no access")
                case .notDetermined:
                    return Effect(value: .requestAccess)
                case .restricted:
                    print("restricted")
                case .unknown:
                    print("unknown")
                }
            }

        case .fetchCalendars:
            return environment.eventsManager.fetchCalendars()
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(Action.fetchCalendarsResponse)

        case .fetchCalendarsResponse(let result):
            switch result {
            case .success(let calendars):
                state.calendars = calendars
            case .failure(let error):
                print(error.localizedDescription)
            }
            return .none

        case .fetchEvents:
            let year = Calendar.current.component(.year, from: Date())
            if let from = Calendar.current.date(from: DateComponents(year: year)),
               let to = Calendar.current.date(from: DateComponents(year: year + 1, day: 0)) {
                return environment.eventsManager.fetchEvents(from: from, to: to)
                    .receive(on: environment.mainQueue)
                    .catchToEffect()
                    .map(Action.fetchEventsResponse)
            }
            return .none

        case .fetchEventsForCalendar(let calendarId):
            let from = state.selectedMonth.firstDay
            let to = state.selectedMonth.lastDay
            return environment.eventsManager.fetchEvents(from: from, to: to, calendarId: calendarId)
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
            
        case let .addEvent(title, startDate, endDate, calendarId):
            return environment.eventsManager.addEvent(title: title, startDate: startDate, endDate: endDate, calendarId: calendarId)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(Action.addEventResponse)

        case .addEventResponse:
            return Effect(value: .fetchEvents)

        case let .removeEvent(event):
            return environment.eventsManager.removeEvent(event: event)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(Action.removeEventResponse)
                    
        case .removeEventResponse:
            return Effect(value: .fetchEvents)
        }
        return .none
    }

    static let initialState = State()

    static let previewState = State()

    static let previewStore = Store(
        initialState: Events.previewState,
        reducer: Events.reducer,
        environment: Main.initialEnvironment
    )
}
