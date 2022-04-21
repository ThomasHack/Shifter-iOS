//
//  MonthView.swift
//  Shifter
//
//  Created by Hack, Thomas on 20.04.22.
//

import ComposableArchitecture
import SwiftUI

struct MonthView: View {
    @Environment(\.calendar) var calendar

    var store: Store<Home.HomeFeatureState, Home.Action>
    var month: Date
    
    var weeks: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: month) else { return [] }
        return calendar.generateDates(
            inside: monthInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0, weekday: calendar.firstWeekday)
        )
    }

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                Text(DateFormatter.month.string(from: month))
                    .font(.system(size: 24, weight: .bold, design: .default))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                
                HStack{
                    ForEach(0..<7, id: \.self) {index in
                        Text(viewStore.events.localizedWeekdays[index].uppercased())
                            .font(.system(size: 16, weight: .semibold, design: .default))
                            .frame(maxWidth: .infinity)
                    }
                }
                
                ForEach(weeks, id: \.self) { week in
                    WeekView(week: week, store: store)
                }
                
                Spacer()
            }
        }
    }
}
