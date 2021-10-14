//
//  ShiftTemplate.swift
//  Shifter
//
//  Created by Hack, Thomas on 14.10.21.
//

import Foundation

struct ShiftTemplate: Codable, Equatable, Hashable {
    private(set) var uid = UUID()
    var title: String
    var startTime: Time
    var endTime: Time
}
