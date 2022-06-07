//
//  DayView.swift
//  Shifter
//
//  Created by Hack, Thomas on 20.04.22.
//

import ComposableArchitecture
import SwiftUI

struct DayView: View {
    var store: Store<Day.State, Day.Action>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                Menu {
                    if !viewStore.events.isEmpty {
                        Button(role: .destructive, action: {
                            // viewStore.send(.deleteShiftForDate(date: date))
                        }, label: {
                            Text("Delete")
                            Image(systemName: "trash")
                        })
                        .foregroundColor(Color.red)
                    }
                    
    //                ForEach(viewStore.state.shiftTemplates, id: \.self) { shift in
    //                    Button {
    //                        // viewStore.send(.addShiftForDate(shift: shift, date: date))
    //                    } label: {
    //                        Text(shift.title)
    //                    }
    //                }
                } label: {
                    VStack(spacing: 0) {
                        
                        Text("\(String(DateFormatter.day.string(from: viewStore.day)))")
                            .font(.system(size: 16, weight: .bold, design: .default))
                            .foregroundColor(Color.white).opacity(viewStore.isToday ? 1.0 : 0.8)
                            .frame(maxWidth: .infinity)
                            .padding(8)
                            .background(viewStore.isToday ? Color("primary") : Color("secondary"))
                        
                        VStack {
                            if !viewStore.events.isEmpty {
                                Circle()
                                    .foregroundColor(Color("tertiary"))
                                    .frame(width: 8, height: 8)

                                ForEach(viewStore.events, id: \.self) { event in
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
                .buttonStyle(.plain)
            }
        }
    }
}
