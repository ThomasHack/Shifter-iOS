//
//  ShifterApp.swift
//  Shifter
//
//  Created by Hack, Thomas on 23.09.21.
//

import ComposableArchitecture
import SwiftUI

@main
struct ShifterApp: App {
    var store: Store<Main.State, Main.Action> = Main.store

    @SceneBuilder
    var body: some Scene {
        WindowGroup {
            MainView(store: store)
        }
    }
}
