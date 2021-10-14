//
//  Main.swift
//
//
//

import ComposableArchitecture
import Foundation

enum Main {
    struct State: Equatable {
        var home: Home.State
        var settings: Settings.State
        var events: Events.State
        var shared: Shared.State
        var createShift: CreateShift.State

        var homeFeature: Home.HomeFeatureState {
            get { Home.HomeFeatureState(home: self.home, events: self.events, shared: self.shared) }
            set { self.home = newValue.home; self.events = newValue.events; self.shared = newValue.shared; }
        }

        var settingsFeature: Settings.FeatureState {
            get { Settings.FeatureState(settings: self.settings, events: self.events, shared: self.shared) }
            set { self.settings = newValue.settings; self.events = newValue.events; self.shared = newValue.shared }
        }

        var createShiftFeature: CreateShift.FeatureState {
            get { CreateShift.FeatureState(createShift: self.createShift, shared: self.shared) }
            set { self.createShift = newValue.createShift; self.shared = newValue.shared }
        }
    }

    enum Action {
        case home(Home.Action)
        case settings(Settings.Action)
        case events(Events.Action)
        case shared(Shared.Action)
        case createShift(CreateShift.Action)
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let eventsManager: EventsManager
    }

    static let reducer = Reducer<State, Action, Environment>.combine(
        Reducer { _, action, _ in
            switch action {
            case .home, .settings, .events, .shared, .createShift:
                return .none
            }
        },
        Home.reducer.pullback(
            state: \.homeFeature,
            action: /Action.home,
            environment: { $0 }
        ),
        Settings.reducer.pullback(
            state: \.settingsFeature,
            action: /Action.settings,
            environment: { $0 }
        ),
        Events.reducer.pullback(
            state: \.events,
            action: /Action.events,
            environment: { $0 }
        ),
        Shared.reducer.pullback(
            state: \.shared,
            action: /Action.shared,
            environment: { $0 }
        ),
        CreateShift.reducer.pullback(
            state: \.createShiftFeature,
            action: /Action.createShift,
            environment: { $0 }
        )
    )

    static let initialEnvironment = Environment(
        mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
        eventsManager: EventsManager()
    )

    static let initialState = State(
        home: Home.initialState,
        settings: Settings.initialState,
        events: Events.initialState,
        shared: Shared.initialState,
        createShift: CreateShift.initialState
    )

    static let store = Store<Main.State, Main.Action>(
        initialState: initialState,
        reducer: reducer,
        environment: initialEnvironment
    )

    static let previewState = State(
        home: Home.previewState,
        settings: Settings.previewState,
        events: Events.previewState,
        shared: Shared.previewState,
        createShift: CreateShift.initialState
    )

    static let previewStore = Store<Main.State, Main.Action>(
        initialState: Main.previewState,
        reducer: Main.reducer,
        environment: Main.initialEnvironment
    )
}

extension Store where State == Main.State, Action == Main.Action {
    var home: Store<Home.HomeFeatureState, Home.Action> {
        scope(state: \.homeFeature, action: Main.Action.home)
    }

    var settings: Store<Settings.FeatureState, Settings.Action> {
        scope(state: \.settingsFeature, action: Main.Action.settings)
    }

    var createShift: Store<CreateShift.FeatureState, CreateShift.Action> {
        scope(state: \.createShiftFeature, action: Main.Action.createShift)
    }
}
