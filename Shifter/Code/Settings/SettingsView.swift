//
//  SettingsView.swift
//  
//
//

import ComposableArchitecture
import SwiftUI

struct SettingsView: View {
    var store: Store<Settings.FeatureState, Settings.Action>

    var body: some View {
        NavigationView {
            WithViewStore(self.store) { viewStore in
                VStack {
                    HStack {
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

                    HStack {
                        Button {
                            viewStore.send(.fetchCalendars)
                        } label: {
                            Text("Fetch Calendars")
                        }

                        Button {
                            viewStore.send(.test)
                        } label: {
                            Text("Test")
                        }
                    }

                    VStack {
                        ForEach(viewStore.events.calendars, id: \.self) { calendar in
                            Button {
                                viewStore.send(.selectCalendar(calendar))
                            } label: {
                                Text("\(calendar.title)")
                            }
                        }
                    }
                    .background(Color(.secondarySystemBackground))
                    .padding()

                    Text(viewStore.shared.calendarId ?? "-")

                    VStack {
                        ForEach(viewStore.shared.shiftTemplates, id: \.self) { template in
                            HStack {
                                Text("\(template.title) | \(template.startTime.hours):\(template.startTime.minutes) - \(template.endTime.hours):\(template.endTime.minutes) ")
                                Button {
                                    viewStore.send(.deleteTemplate(template))
                                } label: {
                                    Image(systemName: "trash")
                                }
                            }
                        }
                    }

                    Spacer()

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
