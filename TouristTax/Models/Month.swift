//
//  Month.swift
//  TouristTax
//
//  Created by Michele Coppola on 20/07/25.
//

import Foundation

struct YearMonth: Hashable {
    let year: Int
    let month: Int
}

// Helper struct to represent a month
struct MonthSection: Identifiable {
    let id = UUID()
    let year: Int
    let month: Int
    let bookings: [Booking]
    var totalGuests: Int {
        bookings.reduce(0) { $0 + $1.numberOfGuests }
    }
    var totalOverNightStays: Int {
        bookings.reduce(0) { $0 + $1.totalOvernightStays }
    }
    var totalTouristTaxt: Double {
        bookings.reduce(0) { $0 + $1.totalTouristTax }
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        let components = DateComponents(year: year, month: month)
        let date = Calendar.current.date(from: components) ?? Date()
        return formatter.string(from: date)
    }
}
