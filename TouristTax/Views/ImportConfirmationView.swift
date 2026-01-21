//
//  ImportConfirmationView.swift
//  TouristTax
//
//  Created by Michele Coppola on 30/07/25.
//

import SwiftUI
import SwiftData

struct ImportConfirmationView: View {
    @State private var bookingsToConfirm: [ImportedBooking]
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var selectedBookings: Set<UUID> = []
    @State private var touristTaxValue: Double = 4.5
    @State private var isImporting = false
    
    init(importedBookings: [ImportedBooking]) {
        self._bookingsToConfirm = State(initialValue: importedBookings)
        // Select all bookings by default
        self._selectedBookings = State(initialValue: Set(importedBookings.map { $0.id }))
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack {
                    HStack {
                        Text("Tassa di Soggiorno:")
                            .font(.headline)
                        
                        Spacer()
                        
                        Stepper(value: $touristTaxValue, in: 0...10, step: 0.5) {
                            Text(touristTaxValue, format: .currency(code: "EUR"))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                
                List {
                    // Use $bookingsToConfirm to pass bindings to the rows
                    Section {
                        ForEach($bookingsToConfirm) { $booking in
                            ImportPreviewRow(
                                booking: $booking,
                                touristTax: touristTaxValue,
                                isSelected: selectedBookings.contains(booking.id)
                            ) {
                                toggleSelection(for: booking.id)
                            }
                        }
                    } header: {
                        HStack {
                            Text("(\(bookingsToConfirm.count) prenotazioni)")
                            Spacer()
                            Button(selectedBookings.count == bookingsToConfirm.count ? "Deseleziona Tutte" : "Seleziona Tutte") {
                                if selectedBookings.count == bookingsToConfirm.count {
                                    selectedBookings.removeAll()
                                } else {
                                    selectedBookings = Set(bookingsToConfirm.map { $0.id })
                                }
                            }
                            .font(.caption)
                            .foregroundStyle(.blue)
                        }
                    }
                }
            }
            .navigationTitle("Importa Prenotazioni")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Annulla") { dismiss() }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Importa") {
                        importSelectedBookings()
                    }
                    .disabled(selectedBookings.isEmpty || isImporting)
                }
            }
            .overlay {
                if isImporting {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .overlay {
                            ProgressView("Importando le prenotazioni...")
                                .padding()
                                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
                        }
                }
            }
        }
    }
    
    private func toggleSelection(for id: UUID) {
        if selectedBookings.contains(id) {
            selectedBookings.remove(id)
        } else {
            selectedBookings.insert(id)
        }
    }
    
    private func importSelectedBookings() {
        isImporting = true
        
        Task {
            await MainActor.run {
                let bookingsToImport = bookingsToConfirm
                    .filter { selectedBookings.contains($0.id) }
                    .compactMap { $0.toBooking(touristTaxValue: touristTaxValue) }
                
                for booking in bookingsToImport {
                    modelContext.insert(booking)
                }
                
                try? modelContext.save()
                
                isImporting = false
                dismiss()
            }
        }
    }
}

#Preview {
    ImportConfirmationView(importedBookings: [ImportedBooking(date: "2025-07-20", numberOfGuests: 5, numberOfNights: 3), ImportedBooking(date: "2025-07-27", numberOfGuests: 3, numberOfNights: 2)])
}
