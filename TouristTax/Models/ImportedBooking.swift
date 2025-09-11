//
//  ImportedBooking.swift
//  TouristTax
//
//  Created by Michele Coppola on 01/08/25.
//

import Foundation

struct ImportedBooking: Codable, Identifiable {
    let id = UUID()
    let date: String
    let numberOfGuests: Int
    let numberOfNights: Int
    
    // Convert to Booking model
    func toBooking(touristTaxValue: Double = 4.5) -> Booking? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = formatter.date(from: self.date) else {
            return nil
        }
        
        return Booking(
            date: date,
            touristTaxValue: touristTaxValue,
            numberOfGuests: numberOfGuests,
            numberOfNights: numberOfNights
        )
    }
}
