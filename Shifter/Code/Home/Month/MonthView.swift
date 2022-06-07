//
//  MonthView.swift
//  Shifter
//
//  Created by Hack, Thomas on 20.04.22.
//

import ComposableArchitecture
import SwiftUI

struct MonthView: View {
    var store: Store<Month.State, Month.Action>

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                Text(DateFormatter.month.string(from: viewStore.month))
                    .font(.system(size: 24, weight: .bold, design: .default))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                
                HStack{
                    ForEach(0..<7, id: \.self) {index in
                        Text(viewStore.localizedWeekdays[index].uppercased())
                            .font(.system(size: 16, weight: .semibold, design: .default))
                            .frame(maxWidth: .infinity)
                    }
                }
                
                ForEach(viewStore.weeks, id: \.self) { week in
                    let store = Store(initialState: Week.State(events: viewStore.events, week: week), reducer: Week.reducer, environment: Main.initialEnvironment)
                    WeekView(store: store)
                }
                
                Spacer()
            }
            .onAppear {
                viewStore.send(.fetchEvents)
            }
        }
    }
}
