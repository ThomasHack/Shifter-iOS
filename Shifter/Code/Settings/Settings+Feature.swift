//
//  Home+HomeFeature.swift
//
//
//

import ComposableArchitecture
import Foundation

extension Settings {
    @dynamicMemberLookup

    struct FeatureState: Equatable {
        var settings: Settings.State
        var events: Events.State
        var shared: Shared.State

        public subscript<T>(dynamicMember keyPath: WritableKeyPath<Settings.State, T>) -> T {
            get { settings[keyPath: keyPath] }
            set { settings[keyPath: keyPath] = newValue }
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
        initialState: Settings.FeatureState(
            settings: Settings.initialState,
            events: Events.initialState,
            shared: Shared.initialState
        ),
        reducer: Settings.reducer,
        environment: Main.initialEnvironment
    )
}
