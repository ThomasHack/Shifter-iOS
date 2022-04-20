//
//  WeekView.swift
//  Shifter
//
//  Created by Hack, Thomas on 20.04.22.
//

import ComposableArchitecture
import SwiftUI

struct WeekView: View {
    @Environment(\.calendar) var calendar

    var week: Date
    var store: Store<Home.HomeFeatureState, Home.Action>
    
    var days: [Date] {
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: week) else { return [] }
        return calendar.generateDates(
            inside: weekInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )
    }

    var body: some View {
        WithViewStore(store) { viewStore in
            HStack {
                ForEach(days, id: \.self) { date in
                    HStack {
                        if calendar.isDate(week, equalTo: date, toGranularity: .month) {
                            DayView(date: date, store: store)
                        } else {
                            DayView(date: date, store: store).hidden()
                        }
                    }
                }
            }
        }
    }
}
