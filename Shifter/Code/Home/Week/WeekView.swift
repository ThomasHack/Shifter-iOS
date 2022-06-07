//
//  WeekView.swift
//  Shifter
//
//  Created by Hack, Thomas on 20.04.22.
//

import ComposableArchitecture
import SwiftUI

struct WeekView: View {
    var store: Store<Week.State, Week.Action>

    var body: some View {
        WithViewStore(store) { viewStore in
            HStack(spacing: 4) {
                ForEach(viewStore.days, id: \.self) { day in
                    HStack {
                        let store = Store(initialState: Day.State(events: viewStore.events, day: day), reducer: Day.reducer, environment: Main.initialEnvironment)
                        if Calendar.current.isDate(viewStore.week, equalTo: day, toGranularity: .month) {
                            DayView(store: store)
                        } else {
                            DayView(store: store).opacity(0.2)
                        }
                    }
                }
            }
        }
    }
}
