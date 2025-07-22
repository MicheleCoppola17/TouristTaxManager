//
//  NewBookingView.swift
//  TouristTax
//
//  Created by Michele Coppola on 21/07/25.
//

import SwiftUI
import SwiftData

struct NewBookingView: View {
    let booking: Booking
    
    @State private var date: Date
    @State private var touristTaxValue: Double
    @State private var numberOfGuests: Int
    @State private var numberOfNights: Int
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    init(booking: Booking?) {
        let bookingToEdit: Booking
        if let booking {
            bookingToEdit = booking
        } else {
            bookingToEdit = Booking(date: .now, numberOfGuests: 2, numberOfNights: 3)
        }
        
        self.booking = bookingToEdit
        self.date = bookingToEdit.date
        self.touristTaxValue = bookingToEdit.touristTaxValue
        self.numberOfGuests = bookingToEdit.numberOfGuests
        self.numberOfNights = bookingToEdit.numberOfNights
    }
    
    var body: some View {
        Form {
            Section(header: Text("Booking Info")) {
                DatePicker("Check-In Date", selection: $date, displayedComponents: .date)
                Picker("Number of Guests", selection: $numberOfGuests) {
                    ForEach(1..<10, id: \.self) { number in
                        Text("\(number)").tag(number)
                    }
                }
                Picker("Number of Nights", selection: $numberOfNights) {
                    ForEach(1..<10, id: \.self) { number in
                        Text("\(number)").tag(number)
                    }
                }
            }
        }
        .navigationTitle("New Booking")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") {
                    saveEdits()
                    dismiss()
                }
            }
        }
    }
    
    private func saveEdits() {
        booking.date = date
        booking.numberOfGuests = numberOfGuests
        booking.numberOfNights = numberOfNights
        context.insert(booking)
    }
}

#Preview(traits: .bookingSampleData) {
    NewBookingView(booking: nil)
}
