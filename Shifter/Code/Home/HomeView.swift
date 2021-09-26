//
//  HomeView.swift
//  
//
//

import ComposableArchitecture
import SwiftUI

struct HomeView: View {
    var store: Store<Home.State, Home.Action>

    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 5)

    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                Text("Home")
                Button {
                    viewStore.send(.requestAccess)
                } label: {
                    Text("Request Access")
                }

                Button {
                    viewStore.send(.getAuthorizationStatus)
                } label: {
                    Text("Get Status")
                }

                Button {
                    viewStore.send(.fetchEvents)
                } label: {
                    Text("Fetch Events")
                }

                LazyVGrid(columns: columns) {
                    ForEach(viewStore.days, id: \.self) { day in
                        Text("\(day.dayDate)")
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(store: Home.previewStore)
    }
}
