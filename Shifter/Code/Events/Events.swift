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

        var calendars: [EKCalendar] = []

        var events: [EKEvent] = []

        var selectedMonth: Int = Calendar.current.dateComponents([.month], from: Date()).month!

        var selectedMonthReadable: String {
            let date = Calendar.current.date(from: DateComponents(year: Date().currentYear, month: selectedMonth, day: 1))!
            let formatter = DateFormatter()
            formatter.dateFormat = "LLLL"
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
        case requestAccess
        case requestAccessResponse(Result<Bool, EventsManagerError>)
        case getAuthorizationStatus
        case getAuthorizationStatusResponse(Result<Bool, EventsManagerError>)
        case fetchCalendars
        case fetchCalendarsResponse(Result<[EKCalendar], EventsManagerError>)
        case fetchEvents
        case fetchEventsForCalendar(String)
        case fetchEventsResponse(Result<[EKEvent], EventsManagerError>)
    }

    typealias Environment = Main.Environment

    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .previousMonth:
            state.selectedMonth -= 1
            return Effect(value: .fetchEvents)

        case .nextMonth:
            state.selectedMonth += 1
            return Effect(value: .fetchEvents)

        case .requestAccess:
            return environment.eventsManager.requestAccess()
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(Action.requestAccessResponse)

        case .requestAccessResponse:
            break

        case .getAuthorizationStatus:
            return environment.eventsManager.getStatus()
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(Action.getAuthorizationStatusResponse)

        case .getAuthorizationStatusResponse(let result):
            switch result {
            case .success:
                print("getAuthorizationStatus: success")
            case .failure(let error):
                print(error.localizedDescription)
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
            let date = Calendar.current.date(from: DateComponents(year: Date().currentYear, month: state.selectedMonth, day: 1))!
            let from = date.firstDay
            let to = date.lastDay
            return environment.eventsManager.fetchEvents(from: from, to: to)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(Action.fetchEventsResponse)

        case .fetchEventsForCalendar(let calendarId):
            let date = Calendar.current.date(from: DateComponents(year: Date().currentYear, month: state.selectedMonth, day: 1))!
            let from = date.firstDay
            let to = date.lastDay
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
