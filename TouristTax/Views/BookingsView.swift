//
//  BookingsView.swift
//  TouristTax
//
//  Created by Michele Coppola on 21/07/25.
//

import SwiftUI
import SwiftData

struct BookingsView: View {
    @Query(sort: \Booking.date) private var bookings: [Booking]
    @State private var isPresentingNewBookingView: Bool = false
    
    var body: some View {
        NavigationStack {
            List(bookings) { booking in
                VStack(alignment: .leading) {
                    Text(booking.date, style: .date)
                        .padding()
                    HStack {
                        Label("\(booking.numberOfGuests)", systemImage: "person.3")
                        Spacer()
                        Text(booking.totalTouristTax, format: .currency(code: "EUR"))
                    }
                    .font(.callout)
                    .padding()
                }
            }
            .navigationTitle("Bookings")
        }
    }
}

#Preview(traits: .bookingSampleData) {
    BookingsView()
}
