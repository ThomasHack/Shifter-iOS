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
                    Color(.secondarySystemBackground)
                        .edgesIgnoringSafeArea(.all)

                    ScrollView {
                        VStack {
                            CalendarView(store: store)
                        }
                        .padding()
                    }
                    .navigationTitle("Schedule")
                    .navigationBarItems(trailing: HStack {
                        Button {
                            viewStore.send(.toggleCreateShiftModal(toggle: true))
                        } label: {
                            Image(systemName: "plus")
                        }
                    })
                    .sheet(isPresented: viewStore.binding(
                        get: \.showCreateShiftModal,
                        send: Home.Action.toggleCreateShiftModal)
                    ) {
                        CreateShiftView(store: Main.store.createShift)
                    }
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
