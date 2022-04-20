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

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                HStack{
                    ForEach(0..<7, id: \.self) {index in
                        Text(viewStore.events.localizedWeekdays[index].uppercased())
                            .font(.system(size: 16, weight: .semibold, design: .default))
                            .frame(maxWidth: .infinity)
                    }
                }
                
                ForEach(viewStore.events.weeks, id: \.self) { week in
                    WeekView(week: week, store: store)
                }
            }
        }
    }
}
