//
//  EventsCalendarManager.swift
//
//
//

import Combine
import Foundation
import EventKit
import CoreMedia

public class EventsManager: NSObject {

    public private(set) var eventStore = EKEventStore()

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

    func fetchCalendars() -> AnyPublisher<[EKCalendar], EventsManagerError> {
        Future { promise in
            let calendars = self.eventStore.calendars(for: .event)
            promise(.success(calendars))
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

    func fetchEvents(from: Date, to: Date, calendarId: String) -> AnyPublisher<[EKEvent], EventsManagerError> {
        Future { promise in
            let events = self.fetchEvents(startDate: from, endDate: to, filterCalendarIDs: [calendarId])
            promise(.success(events))
        }
        .eraseToAnyPublisher()
    }
    
    func addEvent(title: String, startDate: Date, endDate: Date, calendarId: String) -> AnyPublisher<Bool, EventsManagerError> {
        Future { promise in
            self.saveEvent(title: title, startDate: startDate, endDate: endDate, calendarId: calendarId)
            promise(.success(true))
        }
        .eraseToAnyPublisher()
    }

    // MARK: - Private methods

    private func requestAccess(completion: @escaping EKEventStoreRequestAccessCompletionHandler) {
        self.eventStore.requestAccess(to: EKEntityType.event) { (accessGranted, error) in
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
        return events
    }
    
    private func saveEvent(title: String, startDate: Date, endDate: Date, calendarId: String) {
        guard let calendar = self.eventStore.calendar(withIdentifier: calendarId) else { return }
        
        let event = EKEvent(eventStore: self.eventStore)
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.calendar = calendar
        
        do {
            try self.eventStore.save(event, span: .thisEvent)
        } catch {
            print(error.localizedDescription)
        }
    }
}
