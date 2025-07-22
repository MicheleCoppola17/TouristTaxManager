import SwiftUI
import SwiftData

struct BookingsByMonthView: View {
    @Query(sort: \Booking.date) private var bookings: [Booking]
    
    @State private var isPresentingNewBookingView: Bool = false

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
            }
            .sheet(isPresented: $isPresentingNewBookingView) {
                NavigationStack {
                    NewBookingView(booking: nil)
                }
            }
            .overlay {
                if groupedBookings.isEmpty {
                    ContentUnavailableView("Start adding bookings", systemImage: "plus")
                }
            }
        }
    }
}

#Preview(traits: .bookingSampleData) {
    BookingsByMonthView()
}
