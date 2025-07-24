//
//  Booking.swift
//  TouristTax
//
//  Created by Michele Coppola on 20/07/25.
//

import Foundation
import SwiftData

@Model
class Booking: Identifiable {
    var id: UUID
    var date: Date
    var touristTaxValue: Double
    var numberOfGuests: Int
    var numberOfNights: Int
    var totalOvernightStays: Int {
        return numberOfNights * numberOfGuests
    }
    var totalTouristTax: Double {
        return Double(numberOfNights * numberOfGuests) * touristTaxValue
    }
    
    init(id: UUID = UUID(), date: Date, touristTaxValue: Double, numberOfGuests: Int, numberOfNights: Int) {
        self.id = id
        self.date = date
        self.touristTaxValue = touristTaxValue
        self.numberOfGuests = numberOfGuests
        self.numberOfNights = numberOfNights
    }
}
