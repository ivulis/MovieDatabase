//
//  HomeViewController.swift
//  MovieDatabase
//
//  Created by jazeps.ivulis on 22/05/2023.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController {
    
    private var movieListUrl: String = Constants.API.popularMoviesUrl
    private var movies: [Movie] = []

    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMovies(url: movieListUrl)
    }
    
    @IBAction func filterButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Choose movie list...", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Popular", style: .default, handler: changeMovieList))
        alert.addAction(UIAlertAction(title: "Top Rated", style: .default, handler: changeMovieList))
        alert.addAction(UIAlertAction(title: "Upcoming", style: .default, handler: changeMovieList))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func changeMovieList(action: UIAlertAction) {
        switch action.title {
        case "Popular":
            navigationItem.title = Constants.MovieList.popular
            movieListUrl = Constants.API.popularMoviesUrl
        case "Top Rated":
            navigationItem.title = Constants.MovieList.topRated
            movieListUrl = Constants.API.topRatedMoviesUrl
        case "Upcoming":
            navigationItem.title = Constants.MovieList.upcoming
            movieListUrl = Constants.API.upcomingMoviesUrl
        default:
            navigationItem.title = Constants.MovieList.popular
            movieListUrl = Constants.API.popularMoviesUrl
        }
        getMovies(url: movieListUrl)
    }
    
    private func getMovies(url: String) {
        self.activityIndicator(activityIndicatorView: self.loadingView, animated: true)
        
        NetworkManager.fetchMovies(url: url) { movies in
            self.movies = movies.results ?? []
            DispatchQueue.main.async {
                self.homeTableView.reloadData()
                self.activityIndicator(activityIndicatorView: self.loadingView, animated: false)
            }
        }
    }
}//class

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as? MovieTableViewCell else { return UITableViewCell() }
        
        let movie = movies[indexPath.row]
        cell.titleLabel.text = movie.title
        cell.overviewLabel.text = Constants.Icon.overview + (movie.overview != "" ? movie.overview! : "Plot unknown")
        if movie.voteAverage != 0.0 {
            cell.ratingLabel.isHidden = false
            cell.ratingLabel.text = Constants.Icon.rating + movie.voteAverage.stringValue
        }else{
            cell.ratingLabel.isHidden = true
        }
        cell.releaseDateLabel.text = Constants.Icon.releaseDate + movie.releaseDate.longDateString
        cell.posterImageView.sd_setImage(with: URL(string: Constants.API.posterUrl.appending(movie.posterPath ?? "")))
        cell.selectionStyle = .none
        
        return cell
    }//cellForRowAt
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.RowHeight.homeTableViewCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.5) {
            cell.transform = CGAffineTransform.identity
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController else { return }
        
        let movie = movies[indexPath.row]
        vc.movieId = movie.id.stringValue
        
        navigationController?.pushViewController(vc, animated: true)
    }//didSelectRowAt
}
