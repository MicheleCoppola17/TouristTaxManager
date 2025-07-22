//
//  BookingsView.swift
//  TouristTax
//
//  Created by Michele Coppola on 21/07/25.
//

import SwiftUI
import SwiftData

struct BookingsView: View {
    var year: Int? = nil
    var month: Int? = nil

    @Query(sort: \Booking.date) private var allBookings: [Booking]
    @Environment(\.modelContext) private var modelContext
    
    var bookings: [Booking] {
        guard let year = year, let month = month else { return allBookings }
        return allBookings.filter {
            let comps = Calendar.current.dateComponents([.year, .month], from: $0.date)
            return comps.year == year && comps.month == month
        }
    }
    
    var body: some View {
        NavigationStack {
            List(bookings) { booking in
                VStack(alignment: .leading) {
                    Text(booking.date, style: .date)
                        .padding(.vertical)
                        .bold()
                    HStack {
                        Label("\(booking.numberOfGuests)", systemImage: "person.3")
                        Spacer()
                        Text(booking.totalTouristTax, format: .currency(code: "EUR"))
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                }
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        modelContext.delete(booking)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
            .navigationTitle("Month's Details")
            .foregroundStyle(.primary)
        }
    }
}

#Preview(traits: .bookingSampleData) {
    BookingsView()
}
