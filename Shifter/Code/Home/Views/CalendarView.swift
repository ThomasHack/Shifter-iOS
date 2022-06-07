//
//  WeekView.swift
//  Shifter
//
//  Created by Hack, Thomas on 20.04.22.
//

import ComposableArchitecture
import SwiftUI

struct CalendarView: View {
    @Environment(\.calendar) var calendar
    
    @State private var selection = Calendar.current.component(.month, from: Date()) - 1

    var store: Store<Home.HomeFeatureState, Home.Action>

    var year: DateInterval {
        calendar.dateInterval(of: .year, for: Date())!
    }

    var months: [Date] {
        calendar.generateDates(
            inside: year,
            matching: DateComponents(day: 1, hour: 0, minute: 0, second: 0)
        )
    }
    
    var body: some View {
        WithViewStore(store) { viewStore in            
            TabView(selection: viewStore.binding(get: \.selectedIndex, send: Home.Action.updateSelectedIndex)) {
                ForEach(months.indices, id: \.self) { index in
                    let store = Store(initialState: Month.State(month: months[index]),
                                      reducer: Month.reducer,
                                      environment: Main.initialEnvironment)
                    MonthView(store: store)
                }
            }
            .tabViewStyle(
                PageTabViewStyle(indexDisplayMode: .never)
            )
            .animation(.easeIn, value: viewStore.selectedIndex)
            .transition(.slide)
        }
    }
}
