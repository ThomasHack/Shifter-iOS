//
//  SettingsView.swift
//  
//
//

import ComposableArchitecture
import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) private var presentationMode

    var store: Store<Settings.FeatureState, Settings.Action>

    
    init(store: Store<Settings.FeatureState, Settings.Action>) {
        self.store = store
        UITableView.appearance().backgroundColor = .clear // <-- here
    }
    
    var body: some View {
        NavigationView {
            WithViewStore(self.store) { viewStore in
                ZStack {
                    Color("background")
                        .edgesIgnoringSafeArea(.all)

                    VStack {
                        List {
                            Section(header: Text("Calendars")) {
                                ForEach(viewStore.events.calendars, id: \.self) { calendar in
                                    Button {
                                        viewStore.send(.selectCalendar(calendar))
                                    } label: {
                                        HStack {
                                            Circle()
                                                .frame(width: 6, height: 6)
                                                .foregroundColor(Color(calendar.cgColor))
                                            Text("\(calendar.title)")
                                                .foregroundColor(Color(.label))
                                            Spacer()
                                            if let identifier = viewStore.shared.calendarId, calendar.calendarIdentifier == identifier {
                                                Image(systemName: "checkmark")
                                            }
                                        }
                                        
                                    }
                                }
                            }
                            Section(header: Text("Schedules")) {
                                ForEach(viewStore.shared.shiftTemplates, id: \.self) { template in
                                    HStack {
                                        Text(template.title)
                                        Spacer()
                                        Text("\(String(format: "%02d", template.startTime.hours)):\(String(format: "%02d", template.startTime.minutes)) - \(String(format: "%02d", template.endTime.hours)):\(String(format: "%02d", template.endTime.minutes))")
                                        Button {
                                            viewStore.send(.deleteTemplate(template))
                                        } label: {
                                            Image(systemName: "trash")
                                                .foregroundColor(Color.red)
                                        }
                                        .padding(.leading, 8)
                                    }
                                }
                                Button {
                                    viewStore.send(.toggleCreateShiftModal(toggle: true))
                                } label: {
                                    HStack {
                                        Image(systemName: "plus")
                                        Text("Add new schedule")
                                        Spacer()
                                    }
                                }
                            }
                        }
                        .listStyle(.insetGrouped)
                        
                        Spacer()
                    }
                }
                .navigationBarItems(trailing: HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Close")
                    }
                })
                .sheet(isPresented: viewStore.binding(
                    get: \.showCreateShiftModal,
                    send: Settings.Action.toggleCreateShiftModal)
                ) {
                    CreateShiftView(store: Main.store.createShift)
                }
            }
            .navigationTitle("Settings")
        }
        .navigationViewStyle(.stack)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(store: Settings.previewStore)
    }
}
