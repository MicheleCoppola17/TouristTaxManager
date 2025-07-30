//
//  ImportPreviewRow.swift
//  TouristTax
//
//  Created by Michele Coppola on 30/07/25.
//

import SwiftUI

struct ImportPreviewRow: View {
    let booking: ImportedBooking
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
        HStack {
            Button(action: onToggle) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isSelected ? .blue : .gray)
                    .font(.title2)
            }
            .buttonStyle(.plain)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(formattedDate)
                        .font(.headline)
                    Spacer()
                    Text(totalTax, format: .currency(code: "EUR"))
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                }
                
                HStack {
                    Label("\(booking.numberOfGuests)", systemImage: "person.3")
                    Spacer()
                    Label("\(booking.numberOfNights)", systemImage: "powersleep")
                }
                .foregroundStyle(.secondary)
                .font(.caption)
            }
        }
        .padding(.vertical, 4)
        .opacity(isSelected ? 1.0 : 0.6)
    }
}

#Preview {
    ImportPreviewRow(booking: ImportedBooking(date: "2025-07-20", numberOfGuests: 5, numberOfNights: 3), touristTax: 4.5, isSelected: true, onToggle: { })
}
