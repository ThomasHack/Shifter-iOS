//
//  EventsCalendarManager.swift
//
//
//

import Combine
import Foundation
import EventKit
import CoreMedia

enum EventsManagerError: Error {
    case noAccess
    case notDetermined
    case restricted
    case denied
    case unknown

    var localizedDescription: String {
        switch self {
        case .noAccess:
            return "No access"
        case .notDetermined:
            return "Not determined"
        case .restricted:
            return "Restricted"
        case .denied:
            return "Denied"
        case .unknown:
            return "unknown"
        }
    }
}

public class EventsManager: NSObject {

    public private(set) var eventStore = EKEventStore()

    public var events = [EKEvent]()

    override init() {}

    // MARK: - Public methods

    func requestAccess() -> AnyPublisher<Bool, EventsManagerError> {
        Future { promise in
            self.requestAccess { success, error in
                if error != nil {
                    promise(.failure(.noAccess))
                    return
                }
                promise(.success(true))
            }
        }
        .eraseToAnyPublisher()
    }

    func getStatus() -> AnyPublisher<Bool, EventsManagerError> {
        Future { promise in
            let status = self.getAuthorizationStatus()
            switch status {
            case .notDetermined:
                promise(.failure(.notDetermined))
            case .restricted:
                promise(.failure(.restricted))
            case .denied:
                promise(.failure(.denied))
            case .authorized:
                promise(.success(true))
            @unknown default:
                promise(.failure(.unknown))
            }
        }
        .eraseToAnyPublisher()
    }

    func fetchEvents(from: Date, to: Date) -> AnyPublisher<[EKEvent], EventsManagerError> {
        Future { promise in
            let events = self.fetchEvents(startDate: from, endDate: to)
            promise(.success(events))
        }
        .eraseToAnyPublisher()
    }

    // MARK: - Private methods

    private func requestAccess(completion: @escaping EKEventStoreRequestAccessCompletionHandler) {
        eventStore.requestAccess(to: EKEntityType.event) { (accessGranted, error) in
            completion(accessGranted, error)
        }
    }

    private func getAuthorizationStatus() -> EKAuthorizationStatus {
        return EKEventStore.authorizationStatus(for: EKEntityType.event)
    }

    private func fetchEvents(startDate: Date, endDate: Date, filterCalendarIDs: [String] = []) -> [EKEvent] {
        let calendars = self.eventStore.calendars(for: .event).filter { calendar in
            if filterCalendarIDs.isEmpty { return true }
            return filterCalendarIDs.contains(calendar.calendarIdentifier)
        }
        let predicate = self.eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: calendars)
        let events = self.eventStore.events(matching: predicate)
        self.events = events
        return events
    }
}
