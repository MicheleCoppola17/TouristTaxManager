//
//  PreviewContainer.swift
//  TouristTax
//
//  Created by Michele Coppola on 21/07/25.
//

import SwiftUI
import SwiftData

struct BookingSampleData: PreviewModifier {
    static func makeSharedContext() async throws -> ModelContainer {
        let container = try ModelContainer(for: Booking.self, configurations: .init(isStoredInMemoryOnly: true))
        Booking.sampleData.forEach { container.mainContext.insert($0) }
        return container
    }
    
    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }
}

extension PreviewTrait where T == Preview.ViewTraits {
    @MainActor static var bookingSampleData: Self = .modifier(BookingSampleData())
}
