//
//  CreateShiftView.swift
//  Shifter
//
//  Created by Thomas Hack on 29.09.21.
//

import ComposableArchitecture
import SwiftUI

struct CreateShiftView: View {
    @Environment(\.presentationMode) var presentationMode

    var store: Store<CreateShift.FeatureState, CreateShift.Action>
    
    var body: some View {
        NavigationView {
            WithViewStore(self.store) { viewStore in
                List {
                    TextField("Title", text: viewStore.binding(get: \.title, send: CreateShift.Action.updateTitle))
                        .disableAutocorrection(true)

                    DatePicker("Start time", selection: viewStore.binding(get: \.startDate, send: CreateShift.Action.updateStartDate), displayedComponents: .hourAndMinute)

                    DatePicker("End time", selection: viewStore.binding(get: \.endDate, send: CreateShift.Action.updateEndDate), displayedComponents: .hourAndMinute)
                }
                .navigationBarItems(trailing: HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        viewStore.send(.save)
                    } label: {
                        Text("Save")
                    }
                    .disabled(viewStore.title.count < 3)
                })
            }
            .navigationTitle("Create new Shift")
        }
        .navigationViewStyle(.stack)
    }
}

struct CreateShiftView_Previews: PreviewProvider {
    static var previews: some View {
        CreateShiftView(store: CreateShift.previewStore)
    }
}
