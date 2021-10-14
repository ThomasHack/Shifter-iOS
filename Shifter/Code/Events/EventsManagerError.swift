//
//  EventsManagerError.swift
//  Shifter
//
//  Created by Hack, Thomas on 14.10.21.
//

import Foundation

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
