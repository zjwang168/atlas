//
//  PlaceService.swift
//  atlas
//
//  Created by Zijin Wang on 5/21/26.
//

import Foundation
import Supabase

struct PlaceDTO: Decodable, Identifiable {
    let id: UUID
    let name: String
    let subtitle: String?
    let category: String?
    let city: String?
    let country: String?
    let latitude: Double?
    let longitude: Double?
    let ai_summary: String?
}

struct NewPlacePayload: Encodable {
    let name: String
    let subtitle: String
    let category: String
    let city: String
    let country: String
    let latitude: Double
    let longitude: Double
    let ai_summary: String
}

final class PlaceService {
    static let shared = PlaceService()

    private init() {}

    func fetchPlaces() async throws -> [PlaceDTO] {
        let response: [PlaceDTO] = try await supabase
            .from("places")
            .select()
            .execute()
            .value

        return response
    }

    func createPlace(from extractedPlace: ExtractedPlace) async throws {
        let payload = NewPlacePayload(
            name: extractedPlace.name,
            subtitle: extractedPlace.address,
            category: extractedPlace.category,
            city: extractedPlace.city,
            country: extractedPlace.country,
            latitude: extractedPlace.latitude,
            longitude: extractedPlace.longitude,
            ai_summary: extractedPlace.summary
        )

        try await supabase
            .from("places")
            .insert(payload)
            .execute()
    }
}
