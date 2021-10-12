//
//  CreateShift.swift
//  Shifter
//
//  Created by Thomas Hack on 29.09.21.
//

import ComposableArchitecture
import Foundation

enum CreateShift {
    
    struct State: Equatable {
        var title = ""
    }
    
    typealias Environment = Main.Environment
    
    enum Action {
        case save
        case updateTitle(title: String)
    }
    
    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .save:
            return .none

        case .updateTitle(title: let title):
            state.title = title
            return .none
        }
    }
    
    static let initialState = State()

    static let previewState = State()

    static let previewStore = Store(
        initialState: CreateShift.previewState,
        reducer: CreateShift.reducer,
        environment: Main.initialEnvironment
    )
}
