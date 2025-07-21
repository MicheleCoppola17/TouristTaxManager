//
//  TouristTaxApp.swift
//  TouristTax
//
//  Created by Michele Coppola on 20/07/25.
//

import SwiftUI
import SwiftData

@main
struct TouristTaxApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Booking.self)
    }
}
