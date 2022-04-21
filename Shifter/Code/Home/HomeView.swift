//
//  HomeView.swift
//  
//
//

import ComposableArchitecture
import SwiftUI

struct HomeView: View {
    var store: Store<Home.HomeFeatureState, Home.Action>
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 7)
    
    @Environment(\.calendar) var calendar
    private var year: DateInterval {
        calendar.dateInterval(of: .month, for: Date())!
    }
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                ZStack {
                    Color("background")
                        .edgesIgnoringSafeArea(.top)

                    VStack {
                        CalendarView(store: store)
                            .padding()
                    }
                }
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Button {
                            viewStore.send(.previousMonth)
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold, design: .default))
                        }
                        
                        Spacer()

                        Button {
                            viewStore.send(.currentMonth)
                        } label: {
                            Text("Today")
                        }
                        
                        Spacer()
                        
                        Button {
                            viewStore.send(.nextMonth)
                        } label: {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 16, weight: .semibold, design: .default))
                        }
                    }
                }
                .background(Color("background"))
                .navigationTitle("Schedule")
                .navigationBarItems(trailing: HStack {
                    Button {
                        viewStore.send(.toggleSettingsModal(true))
                    } label: {
                        Image(systemName: "gear")
                    }
                })
                .sheet(isPresented: viewStore.binding(
                    get: \.showSettingsModal,
                    send: Home.Action.toggleSettingsModal)
                ) {
                    SettingsView(store: Main.store.settings)
                }
            }
            .navigationViewStyle(.stack)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(store: Home.previewStore)
    }
}
