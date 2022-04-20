//
//  DayView.swift
//  Shifter
//
//  Created by Hack, Thomas on 20.04.22.
//

import ComposableArchitecture
import SwiftUI

struct DayView: View {
    @Environment(\.calendar) var calendar

    var date: Date
    var store: Store<Home.HomeFeatureState, Home.Action>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(spacing: 4) {
                Menu {
                    ForEach(viewStore.state.shiftTemplates.sorted { $0.title < $1.title }, id: \.self) { shift in
                        Button {
                            viewStore.send(.addShiftForDate(shift: shift, date: date))
                        } label: {
                            Text(shift.title)
                        }
                    }
                } label: {
                    VStack(spacing: 0) {
                        Text("\(String(calendar.component(.day, from: date)))")
                            .foregroundColor(Color(.label))
                        
                        VStack {
                            let events = viewStore.events.events.filter { event in
                                return calendar.isDate(event.startDate, inSameDayAs: date)
                            }

                            if events.count > 0 {
                                Circle()
                                    .foregroundColor(.blue)
                                    .frame(width: 8, height: 8)

                                ForEach(events, id: \.self) { event in
                                    Text(event.title)
                                        .font(.system(size: 7))
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                        }
                        .frame(height: 32)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(4)
            .background(Color(.systemBackground))
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 3, y: 3)
        }
    }
}
