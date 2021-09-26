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
            TabView {
                HomeView(store: Home.previewStore)
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }

                SettingsView(store: Settings.previewStore)
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(store: Main.store)
    }
}
