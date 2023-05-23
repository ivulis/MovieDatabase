//
//  MovieDetailViewController.swift
//  MovieDatabase
//
//  Created by jazeps.ivulis on 23/05/2023.
//

import UIKit
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMovieDetails()
        getMovieTrailer()
    }
    
    private func getMovieDetails() {
        //activityIndicator(animated: true)
        
        NetworkManager.fetchMovieDetails(movieId: movieId) { movie in
            self.movie = movie
            DispatchQueue.main.async {
                self.updateDetails()
                //self.activityIndicator(animated: false)
            }
        }
    }
    
    private func getMovieTrailer() {
        NetworkManager.fetchMovieTrailer(movieId: movieId) { trailer in
            self.trailerKey = trailer.results?.first(where: { trl in
                trl.type == "Trailer"
            })?.key ?? "dQw4w9WgXcQ"
        }
    }
    
    func updateDetails() {
        titleLabel.text = movie.title
        posterImageView.sd_setImage(with: URL(string: NetworkManager.posterUrl.appending(movie.posterPath ?? "")))
        movie.genres?.forEach { genreLabel.text?.append("\($0.name ?? ""), ") }
        genreLabel.text?.removeLast(2)
        releaseDateLabel.text?.append(movie.releaseDate ?? "")
        runtimeLabel.text?.append("\((movie.runtime ?? 0) / 60)h \((movie.runtime ?? 0) % 60)m")
        ratingLabel.text?.append("\(movie.voteAverage ?? 0)")
        overviewLabel.text = movie.overview
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination: WebViewController = segue.destination as! WebViewController
        destination.urlString = NetworkManager.youtubeUrl.appending(trailerKey)
    }
}
