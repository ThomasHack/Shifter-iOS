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
}

enum Home {
    struct State: Equatable {
        var selectedMonth: Int = 9

        var days: [Day] {
            let dateComponents = DateComponents(year: Date().currentYear, month: selectedMonth)
            let calendar = Calendar.current
            let date = calendar.date(from: dateComponents)!
            let range = calendar.range(of: .day, in: .month, for: date)!
            return range.map { day in
                let date = calendar.date(from: DateComponents(year: Date().currentYear, month: selectedMonth, day: day))!
                return Day(dayDate: day, startDate: date, endDate: date.endTime)
            }
        }
    }

    enum Action {
        case requestAccess
        case requestAccessResponse(Result<Bool, EventsManagerError>)
        case getAuthorizationStatus
        case getAuthorizationStatusResponse(Result<Bool, EventsManagerError>)
        case fetchEvents
        case fetchEventsResponse(Result<[EKEvent], EventsManagerError>)
    }

    typealias Environment = Main.Environment

    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
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

        case .fetchEvents:
            let from = Date().firstDay
            let to = Date().lastDay
            return environment.eventsManager.fetchEvents(from: from, to: to)
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(Action.fetchEventsResponse)
            
        case .fetchEventsResponse(let events):
            print(events)
            return .none
        }
        return .none
    }

    static let initialState = State()

    static let previewState = State()

    static let previewStore = Store(
        initialState: Home.previewState,
        reducer: Home.reducer,
        environment: Main.initialEnvironment
    )
}
