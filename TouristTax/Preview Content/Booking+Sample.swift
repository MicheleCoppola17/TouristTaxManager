//
//  Booking+Sample.swift
//  TouristTax
//
//  Created by Michele Coppola on 21/07/25.
//

import Foundation

extension Booking {
    static let sampleData: [Booking] =
    [
        Booking(date: Date(timeIntervalSinceNow: -60 * 60 * 24 * 30),
                numberOfGuests: 4,
                numberOfNights: 3),
        Booking(date: Date(timeIntervalSinceNow: -60 * 60 * 24 * 10),
                numberOfGuests: 2,
                numberOfNights: 5),
        Booking(date: Date(timeIntervalSinceNow: -60 * 60 * 24 * 40),
                numberOfGuests: 5,
                numberOfNights: 5)
    ]
}
