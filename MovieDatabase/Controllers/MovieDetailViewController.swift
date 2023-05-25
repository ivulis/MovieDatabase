//
//  MovieDetailViewController.swift
//  MovieDatabase
//
//  Created by jazeps.ivulis on 23/05/2023.
//

import UIKit
import CoreData
import SDWebImage

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    private var movie: MovieDetails = MovieDetails()
    private var trailerKey: String = String()
    var movieId: String = String()
    
    var watchlistMovies: [MovieItems] = []
    var context: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        getMovieDetails()
        getMovieTrailer()
    }
    
    @IBAction func addToWatchlistButtonTapped(_ sender: Any) {
        
        let newMovie = MovieItems(context: self.context!)
        newMovie.id = "\(movie.id ?? 0)"
        newMovie.title = movie.title
        newMovie.releaseDate = convertToLongDate(movie.releaseDate)
        newMovie.runtime = "\(minutesToHoursAndMinutes(movie.runtime))"
        newMovie.rating = String(format: "%.1f", movie.voteAverage ?? 0.0)
        if movie.posterPath != nil {
            newMovie.poster = "\(NetworkManager.posterUrl)\(movie.posterPath ?? NetworkManager.youtubeDefaultVideoKey)"
        }
        
        self.watchlistMovies.append(newMovie)
        saveData()
    }
    
    func saveData() {
        do {
            try context?.save()
            basicAlert(title: "Added!", message: "\(movie.title ?? "Unknown title") has been added to your watchlist.")
        }catch{
            print(error)
        }
    }
    
    private func getMovieDetails() {
        NetworkManager.fetchMovieDetails(movieId: movieId) { movie in
            self.movie = movie
            DispatchQueue.main.async {
                self.updateDetails()
            }
        }
    }
    
    private func getMovieTrailer() {
        NetworkManager.fetchMovieTrailer(movieId: movieId) { trailer in
            self.trailerKey = trailer.results?.first(where: { trl in
                trl.type == "Trailer"
            })?.key ?? NetworkManager.youtubeDefaultVideoKey
        }
    }
    
    func updateDetails() {
        titleLabel.text = movie.title
        posterImageView.sd_setImage(with: URL(string: NetworkManager.posterUrl.appending(movie.posterPath ?? "")))
        movie.genres?.forEach { genreLabel.text?.append("\($0.name ?? ""), ") }
        genreLabel.text?.removeLast(2)
        releaseDateLabel.text = "📅 \(convertToLongDate(movie.releaseDate))"
        runtimeLabel.text = "🎬 \(minutesToHoursAndMinutes(movie.runtime))"
        //ratingLabel.text?.append("\(movie.voteAverage ?? 0)")
        ratingLabel.text = "⭐ \(String(format: "%.1f", movie.voteAverage ?? 0.0))"
        overviewLabel.text = movie.overview
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination: WebViewController = segue.destination as! WebViewController
        destination.urlString = NetworkManager.youtubeUrl.appending(trailerKey)
    }
}
