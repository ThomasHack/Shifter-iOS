//
//  CreateShiftView.swift
//  Shifter
//
//  Created by Thomas Hack on 29.09.21.
//

import ComposableArchitecture
import SwiftUI

struct CreateShiftView: View {
    var store: Store<CreateShift.State, CreateShift.Action>
    
    var body: some View {
        NavigationView {
            WithViewStore(self.store) { viewStore in
                ScrollView {
                    VStack {
                        TextField("Title", text: viewStore.binding(get: \.title, send: CreateShift.Action.updateTitle))
                    }
                    .padding()
                }
                .navigationBarItems(trailing: HStack {
                    Button {
                        viewStore.send(.save)
                    } label: {
                        Text("Save")
                    }
                })
            }
            .navigationTitle("Create new Shift")
        }
    }
}

struct CreateShiftView_Previews: PreviewProvider {
    static var previews: some View {
        CreateShiftView(store: CreateShift.previewStore)
    }
}
