//
//  HomeView.swift
//  
//
//

import ComposableArchitecture
import SwiftUI

struct HomeView: View {
    var store: Store<Home.HomeFeatureState, Home.Action>
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 5)
    
    var body: some View {
        NavigationView {
            WithViewStore(self.store) { viewStore in
                ScrollView {
                    VStack {
                        HStack {
                            Button {
                                viewStore.send(.previousMonth)
                            } label: {
                                Image(systemName: "chevron.left.circle.fill")
                                    .frame(width: 32, height: 32)
                            }
                            
                            Button {
                                viewStore.send(.fetchEvents)
                            } label: {
                                Text(viewStore.events.selectedMonthReadable)
                                    .font(.system(size: 18, weight: .semibold))
                            }
                            
                            Button {
                                viewStore.send(.nextMonth)
                            } label: {
                                Image(systemName: "chevron.right.circle.fill")
                                    .frame(width: 32, height: 32)
                            }
                        }
                        .padding(.vertical, 16)
                        
                        LazyVGrid(columns: columns) {
                            ForEach(viewStore.events.days, id: \.self) { day in
                                VStack(spacing: 4) {
                                    ZStack {
                                        Circle()
                                            .foregroundColor(Color(.secondarySystemBackground))
                                        Text("\(day.dayDate)")
                                            .foregroundColor(Color(.label))
                                    }
                                    .frame(width: 32, height: 32, alignment: .center)
                                    
                                    VStack(spacing: 0) {
                                        if day.events.count > 0 {
                                            Circle()
                                                .foregroundColor(.blue)
                                                .frame(width: 8, height: 8)
                                        }
                                        ForEach(day.events, id: \.self) { event in
                                            Text(event.title)
                                                .font(.system(size: 7))
                                        }
                                    }
                                    .frame(minHeight: 8)
                                }
                            }
                        }
                    }
                }
                .navigationTitle(viewStore.events.selectedMonthReadable)
                .navigationBarItems(trailing: HStack {
                    Button {
                        viewStore.send(.toggleCreateShiftModal(toggle: true))
                    } label: {
                        Image(systemName: "plus")
                    }
                })
                .sheet(isPresented: viewStore.binding(
                    get: \.showCreateShiftModal,
                    send: Home.Action.toggleCreateShiftModal)
                ) {
                    CreateShiftView(store: Main.store.createShift)
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(store: Home.previewStore)
    }
}
