//
//  BookingImportService.swift
//  TouristTax
//
//  Created by Michele Coppola on 30/07/25.
//

import Foundation

struct ImportedBooking: Codable, Identifiable {
    let id = UUID()
    let date: String
    let numberOfGuests: Int
    let numberOfNights: Int
    
    // Convert to Booking model
    func toBooking(touristTaxValue: Double = 4.5) -> Booking? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = formatter.date(from: self.date) else {
            return nil
        }
        
        return Booking(
            date: date,
            touristTaxValue: touristTaxValue,
            numberOfGuests: numberOfGuests,
            numberOfNights: numberOfNights
        )
    }
}

@Observable
class BookingImportService {
    private let baseURL = "https://touristtaxbackend.onrender.com"
    
    var isLoading = false
    var errorMessage: String?
    
    func uploadExcelFile(at url: URL) async -> [ImportedBooking]? {
        isLoading = true
        errorMessage = nil
        
        defer {
            isLoading = false
        }
        
        do {
            // Start accessing security-scoped resource
            guard url.startAccessingSecurityScopedResource() else {
                errorMessage = "Unable to access the selected file"
                return nil
            }
            
            defer {
                url.stopAccessingSecurityScopedResource()
            }
            
            // Create multipart form data
            let boundary = UUID().uuidString
            var request = URLRequest(url: URL(string: "\(baseURL)/upload")!)
            request.httpMethod = "POST"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.timeoutInterval = 30.0 // Add timeout
            
            print("Making request to: \(baseURL)/upload")
            
            // Read file data
            let fileData = try Data(contentsOf: url)
            let fileName = url.lastPathComponent
            
            print("File size: \(fileData.count) bytes")
            
            // Create body
            var body = Data()
            
            // Add file data with the exact parameter name expected by FastAPI
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: application/vnd.ms-excel\r\n\r\n".data(using: .utf8)!)
            body.append(fileData)
            body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
            
            request.httpBody = body
            
            print("Request body size: \(body.count) bytes")
            print("Boundary: \(boundary)")
            
            // Make request
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Check response
            if let httpResponse = response as? HTTPURLResponse {
                print("Response status code: \(httpResponse.statusCode)")
                print("Response headers: \(httpResponse.allHeaderFields)")
                
                guard httpResponse.statusCode == 200 else {
                    // Try to get error message from response body
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("Error response body: \(responseString)")
                        errorMessage = "Server error (\(httpResponse.statusCode)): \(responseString)"
                    } else {
                        errorMessage = "Server returned status code: \(httpResponse.statusCode)"
                    }
                    return nil
                }
            }
            
            // Parse response
            print("Response data: \(String(data: data, encoding: .utf8) ?? "Unable to decode")")
            let importedBookings = try JSONDecoder().decode([ImportedBooking].self, from: data)
            return importedBookings
            
        } catch {
            errorMessage = error.localizedDescription
            return nil
        }
    }
}
