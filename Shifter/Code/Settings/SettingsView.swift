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
        WithViewStore(self.store) { viewStore in
            VStack {
                Text("Settings")
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(store: Settings.previewStore)
    }
}
