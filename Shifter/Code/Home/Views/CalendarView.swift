//
//  WeekView.swift
//  Shifter
//
//  Created by Hack, Thomas on 20.04.22.
//

import ComposableArchitecture
import SwiftUI

struct CalendarView: View {
    var store: Store<Home.HomeFeatureState, Home.Action>

    var body: some View {
        WithViewStore(store) { viewStore in
            HStack(spacing: 16) {
                Button {
                    viewStore.send(.previousMonth)
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold, design: .default))
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 10)
                .background(Color(.systemBackground))
                .cornerRadius(8)
                
                Button {
                    viewStore.send(.resetMonth)
                } label: {
                    Text(viewStore.events.selectedMonthReadable)
                        .font(.system(size: 16, weight: .semibold, design: .default))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .background(Color(.systemBackground))
                        .cornerRadius(8)
                }
                
                Button {
                    viewStore.send(.nextMonth)
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .semibold, design: .default))
                }
                .padding(8)
                .background(Color(.systemBackground))
                .cornerRadius(8)
            }
            .padding(.vertical)
            
            ForEach(viewStore.events.months, id: \.self) { month in
                MonthView(store: store, month: month)
            }
        }
    }
}
