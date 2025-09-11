//
//  CardView.swift
//  TouristTax
//
//  Created by Michele Coppola on 21/07/25.
//

import SwiftUI

struct CardView: View {
    let month: MonthSection
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(month.dateString)
                .font(.title3)
                .bold()
                .padding(.bottom)
            
            Spacer()
            
            HStack {
                Label("\(month.totalGuests)", systemImage: "person.3")
                Spacer()
                Label("\(month.totalOverNightStays)", systemImage: "bed.double")
            }
            .padding(.horizontal)
            .foregroundStyle(.secondary)
        }
        .padding()
        .foregroundStyle(.primary)
    }
}

#Preview() {
    CardView(month: MonthSection(year: 2025, month: 5, bookings: [Booking(date: Date(timeIntervalSinceNow: -60 * 60 * 24 * 60), touristTaxValue: 4.5, numberOfGuests: 3, numberOfNights: 6), Booking(date: Date(timeIntervalSinceNow: -60 * 60 * 24 * 70), touristTaxValue: 4.5, numberOfGuests: 4, numberOfNights: 2)]))
}
