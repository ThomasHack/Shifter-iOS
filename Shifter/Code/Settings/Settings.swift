//
//  Settings.swift
//  
//
//

import ComposableArchitecture
import Foundation

enum Settings {
    struct State: Equatable {}

    enum Action {}

    typealias Environment = Main.Environment

    static let reducer = Reducer<State, Action, Environment> { state, action, _ in
        switch action {
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
