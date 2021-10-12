//
//  Settings.swift
//  
//
//

import ComposableArchitecture
import Foundation

enum Settings {
    struct State: Equatable {}

    enum Action {
        case requestAccess
        case requestAccessResponse(Result<Bool, EventsManagerError>)
        case getAuthorizationStatus
        case getAuthorizationStatusResponse(Result<Bool, EventsManagerError>)
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
        }
        return .none
    }

    static let initialState = State()

    static let previewState = State()

    static let previewStore = Store(
        initialState: Settings.previewState,
        reducer: Settings.reducer,
        environment: Main.initialEnvironment
    )
}
