//
//  MainView.swift
//  
//
//

import ComposableArchitecture
import SwiftUI

struct MainView: View {
    var store: Store<Main.State, Main.Action>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            HomeView(store: Main.store.home)
            .onAppear {
                viewStore.send(.events(.getAuthorizationStatus))
                viewStore.send(.events(.fetchEvents))
                viewStore.send(.events(.fetchCalendars))
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(store: Main.store)
    }
}
