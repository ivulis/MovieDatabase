//
//  NetworkManager.swift
//  MovieDatabase
//
//  Created by jazeps.ivulis on 22/05/2023.
//

import Foundation

class NetworkManager {
    
    static let api = "6d86068be3d5562159db9c1da4fd14d4"
    static let popularMoviesUrl = "https://api.themoviedb.org/3/movie/popular?api_key=\(api)"
    static let upcomingMoviesUrl = "https://api.themoviedb.org/3/movie/upcoming?api_key=\(api)"
    static let posterUrl = "https://image.tmdb.org/t/p/w500/"
    static let youtubeUrl = "https://www.youtube.com/watch?v="
    
    static func fetchMovies(url: String, completion: @escaping (Movies) -> () ) {
        
        guard let url = URL(string: url) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        
        URLSession(configuration: config).dataTask(with: request) { (data, response, err ) in
            
            guard err == nil else {
                print("Error: ", err!)
                return
            }
            
            guard let data = data else { return }
            
            
            do {
                let jsonData = try JSONDecoder().decode(Movies.self, from: data)
                completion(jsonData)
            }catch{
                print("Error: ", error)
            }
            
        }.resume()
    }//fetchMovies
    
    static func fetchMovieDetails(movieId: String, completion: @escaping (MovieDetails) -> () ) {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)?api_key=\(api)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        
        URLSession(configuration: config).dataTask(with: request) { (data, response, err ) in
            
            guard err == nil else {
                print("Error: ", err!)
                return
            }
            
            guard let data = data else { return }
            
            
            do {
                let jsonData = try JSONDecoder().decode(MovieDetails.self, from: data)
                completion(jsonData)
            }catch{
                print("Error: ", error)
            }
            
        }.resume()
    }//fetchMovieDetails
    
    static func fetchMovieTrailer(movieId: String, completion: @escaping (Trailers) -> () ) {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)/videos?api_key=\(api)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        
        URLSession(configuration: config).dataTask(with: request) { (data, response, err ) in
            
            guard err == nil else {
                print("Error: ", err!)
                return
            }
            
            guard let data = data else { return }
            
            
            do {
                let jsonData = try JSONDecoder().decode(Trailers.self, from: data)
                completion(jsonData)
            }catch{
                print("Error: ", error)
            }
            
        }.resume()
    }//fetchMovieTrailer
}
