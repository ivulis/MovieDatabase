//
//  MovieDetails.swift
//  MovieDatabase
//
//  Created by jazeps.ivulis on 23/05/2023.
//

import Foundation

// MARK: - Movie
struct MovieDetails: Codable {
    var adult: Bool? = Bool()
    var backdropPath: String? = String()
    var budget: Int? = Int()
    var genres: [Genre]? = []
    var homepage: String? = String()
    var id: Int? = Int()
    var imdbID: String? = String()
    var originalLanguage: String? = String()
    var originalTitle: String? = String()
    var overview: String? = String()
    var popularity: Double? = Double()
    var posterPath: String? = String()
    var productionCompanies: [ProductionCompany]? = []
    var productionCountries: [ProductionCountry]? = []
    var releaseDate: String? = String()
    var revenue: Int? = Int()
    var runtime: Int? = Int()
    var spokenLanguages: [SpokenLanguage]? = []
    var status: String? = String()
    var tagline: String? = String()
    var title: String? = String()
    var video: Bool? = Bool()
    var voteAverage: Double? = Double()
    var voteCount: Int? = Int()
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case budget, genres, homepage, id
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue, runtime
        case spokenLanguages = "spoken_languages"
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

// MARK: - Genre
struct Genre: Codable {
    let id: Int?
    let name: String?
}

// MARK: - ProductionCompany
struct ProductionCompany: Codable {
    let id: Int?
    let name, originCountry: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case originCountry = "origin_country"
    }
}

// MARK: - ProductionCountry
struct ProductionCountry: Codable {
    let iso3166_1, name: String?
    
    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
}

// MARK: - SpokenLanguage
struct SpokenLanguage: Codable {
    let englishName, iso639_1, name: String?
    
    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso639_1 = "iso_639_1"
        case name
    }
}
