//
//  ImportPreviewRow.swift
//  TouristTax
//
//  Created by Michele Coppola on 30/07/25.
//

import SwiftUI

struct ImportPreviewRow: View {
    @Binding var booking: ImportedBooking
    let touristTax: Double
    let isSelected: Bool
    let onToggle: () -> Void
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let date = formatter.date(from: booking.date) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            return displayFormatter.string(from: date)
        }
        return booking.date
    }
    
    private var totalTax: Double {
        return Double(booking.numberOfGuests * booking.numberOfNights) * touristTax
    }
    
    var body: some View {
        HStack(spacing: 15) {
            // --- 1. Selection Checkbox ---
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(isSelected ? .blue : .secondary)
                .font(.title2)
                .padding(.trailing, 5)

            VStack(alignment: .leading, spacing: 10) {
                // --- 2. Main Booking Info ---
                HStack {
                    Text(formattedDate)
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer()
                    Text(totalTax, format: .currency(code: "EUR"))
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
                
                // --- 3. Editable Fields in a Grid for perfect alignment ---
                Grid(alignment: .leading, horizontalSpacing: 20) {
                    GridRow(alignment: .center) {
                        Text("Guests:")
                        
                        HStack {
                            Text("\(booking.numberOfGuests)")
                                // A fixed width prevents the layout from shifting when numbers change
                                .frame(width: 35, alignment: .leading)
                            Spacer()
                            Stepper("Guests", value: $booking.numberOfGuests, in: 1...20)
                                .labelsHidden()
                        }
                        .gridColumnAlignment(.trailing) // Align this whole cell to the right
                    }
                    
                    GridRow(alignment: .center) {
                        Text("Nights:")
                        
                        HStack {
                            Text("\(booking.numberOfNights)")
                                .frame(width: 35, alignment: .leading)
                            Spacer()
                            Stepper("Nights", value: $booking.numberOfNights, in: 1...30)
                                .labelsHidden()
                        }
                        .gridColumnAlignment(.trailing)
                    }
                }
                .font(.callout)
                .foregroundStyle(.primary.opacity(0.8))
            }
        }
        .padding(.vertical, 10)
        .contentShape(Rectangle())
        .onTapGesture(perform: onToggle)
        .opacity(isSelected ? 1.0 : 0.6)
    }
}

#Preview {
    ImportPreviewRow(booking: .constant(ImportedBooking(date: "2025-12-12", numberOfGuests: 3, numberOfNights: 5)), touristTax: 4.5, isSelected: true, onToggle: { })
        .padding()
}
