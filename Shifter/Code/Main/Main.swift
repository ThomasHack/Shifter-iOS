//
//  Main.swift
//  
//
//

import ComposableArchitecture
import Foundation

enum Main {
    struct State: Equatable {}

    enum Action {}

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let eventsManager: EventsManager
    }

    static let reducer = Reducer<State, Action, Environment>.combine(
        Reducer { _, action, _ in
            switch action {
            default:
                break
            }
            return .none
        }
    )

    static let initialEnvironment = Environment(
        mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
        eventsManager: EventsManager()
    )

    static let store = Store<Main.State, Main.Action>(
        initialState: State(),
        reducer: reducer,
        environment: initialEnvironment
    )

    static let initialState = State()

    static let previewState = State()

    static let previewStore = Store(
        initialState: Main.previewState,
        reducer: Main.reducer,
        environment: Main.initialEnvironment
    )
}

extension Store where State == Main.State, Action == Main.Action {
    // var home: Store<Home.HomeFeatureState, Home.Action> {
    //     scope(state: \.homeFeature, action: Main.Action.home)
    // }
}
