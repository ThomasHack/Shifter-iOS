//
//  Home+HomeFeature.swift
//
//
//

import ComposableArchitecture
import Foundation

extension CreateShift {
    @dynamicMemberLookup

    struct FeatureState: Equatable {
        var createShift: CreateShift.State
        var shared: Shared.State

        public subscript<T>(dynamicMember keyPath: WritableKeyPath<CreateShift.State, T>) -> T {
            get { createShift[keyPath: keyPath] }
            set { createShift[keyPath: keyPath] = newValue }
        }

        public subscript<T>(dynamicMember keyPath: WritableKeyPath<Shared.State, T>) -> T {
            get { shared[keyPath: keyPath] }
            set { shared[keyPath: keyPath] = newValue }
        }
    }

    static let previewStore = Store(
        initialState: CreateShift.FeatureState(
            createShift: CreateShift.initialState,
            shared: Shared.initialState
        ),
        reducer: CreateShift.reducer,
        environment: Main.initialEnvironment
    )
}
