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
    let ai_summary: String?
    let category: String?
    let city: String?
    let country: String?
    let latitude: Double?
    let longitude: Double?
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
}
