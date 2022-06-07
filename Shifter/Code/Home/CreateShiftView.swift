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
                    HStack {
                        Text("Von - Bis")
                        Spacer()
                        Picker(selection: .constant(1), label: Text("")) {
                            Text("1").tag(1)
                            Text("2").tag(2)
                        }
                        Picker(selection: .constant(1), label: Text("")) {
                            Text("1").tag(1)
                            Text("2").tag(2)
                        }
                    }
                    
                    TextField("Title", text: viewStore.binding(get: \.title, send: CreateShift.Action.updateTitle))
                        .disableAutocorrection(true)

                    DatePicker("Start time", selection: viewStore.binding(get: \.startDate, send: CreateShift.Action.updateStartDate), displayedComponents: .hourAndMinute)

                    DatePicker("End time", selection: viewStore.binding(get: \.endDate, send: CreateShift.Action.updateEndDate), displayedComponents: .hourAndMinute)
                }
                .navigationTitle("Create new Shift")
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
            .navigationBarItems(leading: HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Cancel")
                }
            })
        }
        .navigationViewStyle(.stack)
    }
}

struct CreateShiftView_Previews: PreviewProvider {
    static var previews: some View {
        CreateShiftView(store: CreateShift.previewStore)
    }
}
