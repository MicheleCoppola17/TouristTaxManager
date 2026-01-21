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
            bookingToEdit = Booking(date: .now, touristTaxValue: 4.5, numberOfGuests: 2, numberOfNights: 3)
        }
        
        self.booking = bookingToEdit
        self.date = bookingToEdit.date
        self.touristTaxValue = bookingToEdit.touristTaxValue
        self.numberOfGuests = bookingToEdit.numberOfGuests
        self.numberOfNights = bookingToEdit.numberOfNights
    }
    
    var body: some View {
        Form {
            Section(header: Text("Informazioni Prenotazione")) {
                DatePicker("Data Check-In", selection: $date, displayedComponents: .date)
                Picker("Numero di Ospiti", selection: $numberOfGuests) {
                    ForEach(1..<10, id: \.self) { number in
                        Text("\(number)").tag(number)
                    }
                }
                Picker("Numero di Notti", selection: $numberOfNights) {
                    ForEach(1..<16, id: \.self) { number in
                        Text("\(number)").tag(number)
                    }
                }
            }
            
            Section(header: Text("Tassa di Soggiorno")) {
                HStack {
                    Slider(value: $touristTaxValue, in: 0...10, step: 0.5) {
                        Text("Tassa di Soggiorno: \(touristTaxValue)")
                    }
                    
                    Text(touristTaxValue, format: .currency(code: "EUR"))
                }
            }
        }
        .navigationTitle("Nuova Prenotazione")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Annulla") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Fatto") {
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
