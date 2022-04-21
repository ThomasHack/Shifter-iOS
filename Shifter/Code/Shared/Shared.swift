//
//  Shared.swift
//  
//
//

import ComposableArchitecture
import Foundation

enum Shared {

    static let userDefaults = UserDefaults.standard
    static let calendarIdDefaultsKeyName = "shifter.calendarId"
    static let shiftTemplatesDefaultsKeyName = "shifter.shiftTemplates"

    struct State: Equatable {
        var calendarId: String? {
            didSet {
                userDefaults.set(calendarId, forKey: calendarIdDefaultsKeyName)
            }
        }

        var shiftTemplates: [ShiftTemplate] = [] {
            didSet {
                do {
                    let data = try JSONEncoder().encode(shiftTemplates)
                    userDefaults.set(data, forKey: shiftTemplatesDefaultsKeyName)
                } catch {
                    assertionFailure(error.localizedDescription)
                }
            }
        }
    }

    enum Action {
        case selectCalendar(String)
        case saveShifTemplate(ShiftTemplate)
        case updateShiftTemplate(ShiftTemplate)
        case deleteShiftTemplate(ShiftTemplate)
    }

    typealias Environment = Main.Environment

    static let reducer = Reducer<State, Action, Environment> { state, action, _ in
        switch action {
        case .selectCalendar(let calendarId):
            state.calendarId = calendarId

        case .saveShifTemplate(let template):
            state.shiftTemplates.append(template)

        case .deleteShiftTemplate(let template):
            if let index = state.shiftTemplates.firstIndex(of: template) {
                state.shiftTemplates.remove(at: index)
            }

        case .updateShiftTemplate(let template):
            if let index = state.shiftTemplates.firstIndex(of: template) {
                state.shiftTemplates.remove(at: index)
                state.shiftTemplates.append(template)
            }

        }
        return .none
    }
        .debug()

    static func decodeShiftTemplatesData() -> [ShiftTemplate] {
        do {
            guard let data = userDefaults.value(forKey: shiftTemplatesDefaultsKeyName) as? Data else { return [] }
            let shiftTemplates = try JSONDecoder().decode([ShiftTemplate].self, from: data)
            return shiftTemplates
        } catch {
            assertionFailure(error.localizedDescription)
        }
        return []
    }

    static let initialState = State(
        calendarId: userDefaults.string(forKey: calendarIdDefaultsKeyName),
        shiftTemplates: decodeShiftTemplatesData()
    )

    static let previewState = State()

    static let previewStore = Store(
        initialState: Shared.previewState,
        reducer: Shared.reducer,
        environment: Main.initialEnvironment
    )
}
