//
//  ImportConfirmationView.swift
//  TouristTax
//
//  Created by Michele Coppola on 30/07/25.
//

import SwiftUI
import SwiftData

struct ImportConfirmationView: View {
    let importedBookings: [ImportedBooking]
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var selectedBookings: Set<UUID> = []
    @State private var touristTaxValue: Double = 4.5
    @State private var isImporting = false
    
    init(importedBookings: [ImportedBooking]) {
        self.importedBookings = importedBookings
        // Select all bookings by default
        self._selectedBookings = State(initialValue: Set(importedBookings.map { $0.id }))
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header with tourist tax setting
                VStack {
                    HStack {
                        Text("Tourist Tax:")
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
                
                // Preview list
                List {
                    Section {
                        ForEach(importedBookings) { booking in
                            ImportPreviewRow(
                                booking: booking,
                                touristTax: touristTaxValue,
                                isSelected: selectedBookings.contains(booking.id)
                            ) {
                                toggleSelection(for: booking.id)
                            }
                        }
                    } header: {
                        HStack {
                            Text("Preview (\(importedBookings.count) bookings)")
                            Spacer()
                            Button(selectedBookings.count == importedBookings.count ? "Deselect All" : "Select All") {
                                if selectedBookings.count == importedBookings.count {
                                    selectedBookings.removeAll()
                                } else {
                                    selectedBookings = Set(importedBookings.map { $0.id })
                                }
                            }
                            .font(.caption)
                            .foregroundStyle(.blue)
                        }
                    }
                }
            }
            .navigationTitle("Import Bookings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Import") {
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
                            ProgressView("Importing bookings...")
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
                let bookingsToImport = importedBookings
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
