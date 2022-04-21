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
            GeometryReader { geometry in
                TabView(selection: viewStore.binding(get: \.selectedIndex, send: Home.Action.updateSelectedIndex)) {
                    ForEach(months.indices, id: \.self) { index in
                        MonthView(store: store, month: months[index])
                            .tag(index)
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .tabViewStyle(
                    PageTabViewStyle(indexDisplayMode: .never)
                )
                .animation(.easeInOut, value: viewStore.selectedIndex)
                .transition(.slide)
            }
        }
    }
}
