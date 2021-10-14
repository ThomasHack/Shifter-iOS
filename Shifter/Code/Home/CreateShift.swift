//
//  CreateShift.swift
//  Shifter
//
//  Created by Thomas Hack on 29.09.21.
//

import ComposableArchitecture
import Foundation

enum CreateShift {
    
    struct State: Equatable {
        var title = ""
        var startDate: Date = Date()
        var endDate: Date = Calendar.current.date(byAdding: DateComponents(hour: 1), to: Date())!

        var template = emptyTemplate
    }
    
    typealias Environment = Main.Environment
    
    enum Action {
        case save
        case updateTitle(String)
        case updateStartDate(Date)
        case updateEndDate(Date)

        case shared(Shared.Action)
    }

    static let emptyTemplate = ShiftTemplate(
        title: "",
        startTime: Time(hours: Date().get(.hour), minutes: Date().get(.minute)),
        endTime: Time(
            hours: Calendar.current.date(byAdding: DateComponents(hour: 1), to: Date())!.get(.hour),
            minutes: Calendar.current.date(byAdding: DateComponents(hour: 1), to: Date())!.get(.minute))
    )
    
    static let reducer = Reducer<FeatureState, Action, Environment>.combine(
        Reducer { state, action, environment in
            switch action {
            case .save:
                
                return Effect(value: .shared(.saveShifTemplate(state.template)))

            case .updateTitle(let title):
                state.title = title
                state.template.title = title

            case .updateStartDate(let date):
                let time = Time(hours: date.get(.hour), minutes: date.get(.minute))
                state.startDate = date
                state.template.startTime = time


            case .updateEndDate(let date):
                state.endDate = date
                let time = Time(hours: date.get(.hour), minutes: date.get(.minute))
                state.endDate = date
                state.template.endTime = time

            case .shared:
                break
            }
            return .none
        },
        Shared.reducer.pullback(
            state: \FeatureState.shared,
            action: /Action.shared,
            environment: { $0 }
        )
    )
    
    static let initialState = State()

    static let previewState = State()
}
