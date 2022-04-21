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
            let events = viewStore.events.events.filter { event in
                return calendar.isDate(event.startDate, inSameDayAs: date)
            }
            
            Menu {
                if !events.isEmpty {
                    Button(role: .destructive, action: {
                        viewStore.send(.deleteShiftForDate(date: date))
                    }, label: {
                        Text("Delete")
                        Image(systemName: "trash")
                    })
                    .foregroundColor(Color.red)
                }
                
                ForEach(viewStore.state.shiftTemplates, id: \.self) { shift in
                    Button {
                        viewStore.send(.addShiftForDate(shift: shift, date: date))
                    } label: {
                        Text(shift.title)
                    }
                }
            } label: {
                VStack(spacing: 0) {
                    let isToday = calendar.isDate(date, inSameDayAs: Date())
                    
                    Text("\(String(calendar.component(.day, from: date)))")
                        .font(.system(size: 16, weight: .bold, design: .default))
                        .foregroundColor(Color.white).opacity(isToday ? 1.0 : 0.8)
                        .frame(maxWidth: .infinity)
                        .padding(8)
                        .background(isToday ? Color("primary") : Color("secondary"))
                    
                    VStack {
                        if !events.isEmpty {
                            Circle()
                                .foregroundColor(Color("tertiary"))
                                .frame(width: 8, height: 8)

                            ForEach(events, id: \.self) { event in
                                Text(event.title)
                                    .font(.system(size: 7))
                                    .foregroundColor(Color(.label))
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                    .frame(height: 40)
                }
                .frame(maxWidth: .infinity)
                .background(Color(.systemBackground))
                .cornerRadius(8)
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 2, y: 2)
            }
        }
    }
}
