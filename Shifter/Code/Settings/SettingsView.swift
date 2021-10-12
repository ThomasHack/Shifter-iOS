//
//  SettingsView.swift
//  
//
//

import ComposableArchitecture
import SwiftUI

struct SettingsView: View {
    var store: Store<Settings.State, Settings.Action>

    var body: some View {
        NavigationView {
            WithViewStore(self.store) { viewStore in
                VStack {
                    Button {
                        viewStore.send(.requestAccess)
                    } label: {
                        Text("Request Access")
                    }

                    Button {
                        viewStore.send(.getAuthorizationStatus)
                    } label: {
                        Text("Get Status")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(store: Settings.previewStore)
    }
}
