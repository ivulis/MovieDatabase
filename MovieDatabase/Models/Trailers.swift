//
//  Trailers.swift
//  MovieDatabase
//
//  Created by jazeps.ivulis on 23/05/2023.
//

import Foundation

// MARK: - Trailers
struct Trailers: Codable {
    var id: Int? = Int()
    var results: [Trailer]? = []
}

// MARK: - Result
struct Trailer: Codable {
    var iso639_1: String? = String()
    var iso3166_1: String? = String()
    var name: String? = String()
    var key: String? = String()
    var site: String? = String()
    var size: Int? = Int()
    var type: String? = String()
    var official: Bool? = Bool()
    var publishedAt: String? = String()
    var id: String? = String()

    enum CodingKeys: String, CodingKey {
        case iso639_1 = "iso_639_1"
        case iso3166_1 = "iso_3166_1"
        case name, key, site, size, type, official
        case publishedAt = "published_at"
        case id
    }
}
