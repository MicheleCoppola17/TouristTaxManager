//
//  ImportErrorView.swift
//  TouristTax
//
//  Created by Michele Coppola on 30/07/25.
//

import SwiftUI

struct ImportErrorView: View {
    let error: String
    let onRetry: () -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.orange)
                
                Text("Importazione Fallita")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text(error)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
                
                VStack(spacing: 12) {
                    Button("Riprova") {
                        onRetry()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Annulla") {
                        onDismiss()
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.top)
            }
            .padding()
            .navigationTitle("Errore Importazione")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Fatto") {
                        onDismiss()
                    }
                }
            }
        }
    }
}
#Preview {
    ImportErrorView(error: "Errore", onRetry: { }, onDismiss: { })
}
