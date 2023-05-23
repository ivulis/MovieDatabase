//
//  HomeViewController.swift
//  MovieDatabase
//
//  Created by jazeps.ivulis on 22/05/2023.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController {
    
    private var movieListUrl: String = NetworkManager.popularMoviesUrl
    private var movies: [Movie] = []

    @IBOutlet weak var popularMoviesTableView: UITableView!
    
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
            navigationItem.title = "Popular Movies"
            movieListUrl = NetworkManager.popularMoviesUrl
        case "Top Rated":
            navigationItem.title = "Top Rated Movies"
            movieListUrl = NetworkManager.topRatedMoviesUrl
        case "Upcoming":
            navigationItem.title = "Upcoming Movies"
            movieListUrl = NetworkManager.upcomingMoviesUrl
        default:
            navigationItem.title = "Popular Movies"
            movieListUrl = NetworkManager.popularMoviesUrl
        }
        getMovies(url: movieListUrl)
    }
    
    private func getMovies(url: String) {
        
        NetworkManager.fetchMovies(url: url) { movies in
            self.movies.removeAll()
            self.movies = movies.results ?? []
            dump(self.movies)
            DispatchQueue.main.async {
                self.popularMoviesTableView.reloadData()
                //self.activityIndicator(animated: false)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieTableViewCell else { return UITableViewCell() }
        
        let movie = movies[indexPath.row]
        cell.titleLabel.text = movie.title
        cell.overviewLabel.text = "📝 \(movie.overview ?? "")"
        cell.ratingLabel.text = "⭐ \(movie.voteAverage ?? 0)"
        cell.releaseDateLabel.text = "📅 \(movie.releaseDate ?? "")"
        cell.posterImageView.sd_setImage(with: URL(string: NetworkManager.posterUrl.appending(movie.posterPath ?? "")))
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController else { return }
        
        let movie = movies[indexPath.row]
        vc.movieId = "\(movie.id ?? 0)"
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
