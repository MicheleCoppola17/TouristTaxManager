//
//  Month.swift
//  TouristTax
//
//  Created by Michele Coppola on 20/07/25.
//

import Foundation

enum MonthName: String, CaseIterable {
    case January
    case February
    case March
    case April
    case May
    case June
    case July
    case August
    case September
}

struct Month: Identifiable {
    var id: UUID
    var name: MonthName
    var year: Date
    var bookings: [Booking]
    var totalTouristTax: Double {
        return bookings.reduce(0) { $0 + $1.totalTouristTax }
    }
}
