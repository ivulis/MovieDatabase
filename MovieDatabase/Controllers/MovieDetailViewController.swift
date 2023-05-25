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
    
    
    @IBOutlet weak var addToWatchlistButton: BounceButton!
    @IBOutlet weak var watchTrailerButton: BounceButton!
    
    private var movie: MovieDetails = MovieDetails()
    private var trailerKey: String = String()
    var movieId: String = String()
    
    var watchlistMovies: [MovieItems] = []
    var context: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        checkWatchlist()
        getMovieDetails()
        getMovieTrailer()
    }
    
    @IBAction func addToWatchlistButtonTapped(_ sender: Any) {
        if let movie = watchlistMovies.first(where: { $0.id == movieId }) {
            self.context?.delete(movie)
            self.saveData(adding: false)
        }else{
            let newMovie = MovieItems(context: self.context!)
            newMovie.id = movie.id.stringValue
            newMovie.title = movie.title
            newMovie.releaseDate = movie.releaseDate.longDateString
            newMovie.runtime = movie.runtime.hoursAndMinutes
            newMovie.rating = movie.voteAverage.stringValue
            if let posterPath = movie.posterPath {
                newMovie.poster = Constants.API.posterUrl + posterPath
            }
            
            self.watchlistMovies.append(newMovie)
            saveData(adding: true)
        }
        updateAddToWatchlistButton()
    }
    
    func saveData(adding: Bool) {
        do {
            try context?.save()
            if adding {
                basicAlert(title: "Added!", message: "\(movie.title.stringValue) has been added to your watchlist.")
            }else{
                basicAlert(title: "Removed!", message: "\(movie.title.stringValue) has been removed from your watchlist.")
            }
        }catch{
            print(error)
        }
    }
    
    func checkWatchlist() {
        let request: NSFetchRequest<MovieItems> = MovieItems.fetchRequest()
        do {
            watchlistMovies = try (context?.fetch(request))!
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
        NetworkManager.fetchMovieTrailer(movieId: movieId) { fetchedTrailers in
            guard let trailers = fetchedTrailers.results else {return}
            if !trailers.isEmpty {
                self.trailerKey = trailers.first(where: { trl in
                    trl.type == "Trailer"
                })?.key ?? ""
            }else{
                DispatchQueue.main.async {
                    self.watchTrailerButton.isHidden = true
                }
            }
        }
    }
    
    func updateDetails() {
        titleLabel.text = movie.title
        if let poster = movie.posterPath {
            posterImageView.sd_setImage(with: URL(string: Constants.API.posterUrl.appending(poster)))
        }else{
            posterImageView.sd_setImage(with: URL(string: Constants.Image.posterPlaceholder))
        }
        movie.genres?.forEach { genreLabel.text?.append("\($0.name ?? ""), ") }
        genreLabel.text?.removeLast(2)
        releaseDateLabel.text = Constants.Icon.releaseDate + movie.releaseDate.longDateString
        runtimeLabel.text = Constants.Icon.runtime + movie.runtime.hoursAndMinutes
        if movie.voteAverage != 0.0 {
            ratingLabel.isHidden = false
            ratingLabel.text = Constants.Icon.rating + movie.voteAverage.stringValue
        }else{
            ratingLabel.isHidden = true
        }
        overviewLabel.text = movie.overview != "" ? movie.overview! : "Plot unknown"
        updateAddToWatchlistButton()
    }
    
    func updateAddToWatchlistButton() {
        if watchlistMovies.contains(where: { $0.id == movieId }) {
            changeToAdded(addToWatchlistButton)
        }else{
            changeToAdd(addToWatchlistButton)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination: WebViewController = segue.destination as! WebViewController
        destination.urlString = Constants.API.trailerUrl.appending(trailerKey)
    }
}
