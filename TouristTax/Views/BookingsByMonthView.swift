import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct BookingsByMonthView: View {
    @Query(sort: \Booking.date) private var bookings: [Booking]
    
    @State private var isPresentingNewBookingView: Bool = false
    @State private var importing: Bool = false
    @State private var importService = BookingImportService()
    @State private var showingImportPreview = false
    @State private var importedBookings: [ImportedBooking] = []
    @State private var showingImportError = false

    // Group bookings by year and month
    private var groupedBookings: [MonthSection] {
        let grouped = Dictionary(grouping: bookings) { (booking) -> YearMonth in
            let comps = Calendar.current.dateComponents([.year, .month], from: booking.date)
            return YearMonth(year: comps.year ?? 0, month: comps.month ?? 0)
        }
        return grouped.map { (key, val) in
            MonthSection(year: key.year, month: key.month, bookings: val)
        }.sorted {
            if $0.year != $1.year {
                return $0.year > $1.year
            } else {
                return $0.month > $1.month
            }
        }
    }

    var body: some View {
        NavigationStack {
            List(groupedBookings) { section in
                NavigationLink(destination: BookingsView(year: section.year, month: section.month)) {
                    CardView(month: section)
                }
            }
            .navigationTitle("Months")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { isPresentingNewBookingView = true }) {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .bottomBar) {
                    Button(action: { importing = true }) {
                        HStack {
                            if importService.isLoading {
                                ProgressView()
                                    .scaleEffect(0.8)
                            } else {
                                Image(systemName: "doc.badge.plus")
                            }
                            Text("Import from XLS")
                        }
                        .padding()
                    }
                    .disabled(importService.isLoading)
                    .fileImporter(
                        isPresented: $importing,
                        allowedContentTypes: [.spreadsheet],
                        allowsMultipleSelection: false
                    ) { result in
                        handleFileImport(result)
                    }
                }
            }
            .sheet(isPresented: $isPresentingNewBookingView) {
                NavigationStack {
                    NewBookingView(booking: nil)
                }
            }
            .sheet(isPresented: $showingImportPreview) {
                ImportConfirmationView(importedBookings: importedBookings)
            }
            .alert("Import Error", isPresented: $showingImportError) {
                Button("OK") { }
            } message: {
                Text(importService.errorMessage ?? "An unknown error occurred")
            }
            .overlay {
                if groupedBookings.isEmpty {
                    ContentUnavailableView("Start adding bookings", systemImage: "plus")
                }
            }
        }
    }
    
    private func handleFileImport(_ result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            guard let url = urls.first else { return }
            
            Task {
                if let bookings = await importService.uploadExcelFile(at: url) {
                    await MainActor.run {
                        print("Imported bookings: \(importedBookings.count)")
                        importedBookings = bookings
                        showingImportPreview = true
                    }
                } else {
                    await MainActor.run {
                        showingImportError = true
                    }
                }
            }
            
        case .failure(let error):
            importService.errorMessage = error.localizedDescription
            showingImportError = true
        }
    }
}
#Preview(traits: .bookingSampleData) {
    BookingsByMonthView()
}
