//
//  Home+HomeFeature.swift
//
//
//

import ComposableArchitecture
import Foundation

extension Home {
    @dynamicMemberLookup

    struct HomeFeatureState: Equatable {
        var home: Home.State
        var events: Events.State
        var shared: Shared.State

        public subscript<T>(dynamicMember keyPath: WritableKeyPath<Home.State, T>) -> T {
            get { home[keyPath: keyPath] }
            set { home[keyPath: keyPath] = newValue }
        }

        public subscript<T>(dynamicMember keyPath: WritableKeyPath<Events.State, T>) -> T {
            get { events[keyPath: keyPath] }
            set { events[keyPath: keyPath] = newValue }
        }

        public subscript<T>(dynamicMember keyPath: WritableKeyPath<Shared.State, T>) -> T {
            get { shared[keyPath: keyPath] }
            set { shared[keyPath: keyPath] = newValue }
        }
    }

    static let previewStore = Store(
        initialState: Home.HomeFeatureState(
            home: Home.initialState,
            events: Events.initialState,
            shared: Shared.initialState
        ),
        reducer: Home.reducer,
        environment: Main.initialEnvironment
    )
}
