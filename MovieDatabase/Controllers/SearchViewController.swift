//
//  SearchViewController.swift
//  MovieDatabase
//
//  Created by jazeps.ivulis on 23/05/2023.
//

import UIKit
import SDWebImage

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    let searchVC = UISearchController(searchResultsController: nil)
    private var movies: [Movie] = []
    var keyword: String = String()
    
    @IBOutlet weak var searchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSearchBar()
    }
    
    //MARK: - Create search bar
    func createSearchBar() {
        navigationItem.searchController = searchVC
        searchVC.searchBar.placeholder = "Tap here to search movies by keyword"
        searchVC.searchBar.delegate = self
    }
    
    //MARK: - Search bar enter button
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text, !keyword.isEmpty else {return}
        let trimmedKeyword = keyword.filter {!$0.isWhitespace}
        print(trimmedKeyword)
        
        getMovies(keyword: trimmedKeyword)
    }
    
    //MARK: - Search bar cancel button
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        movies.removeAll()
        searchTableView.reloadData()
    }
    
    private func getMovies(keyword: String) {
        
        NetworkManager.fetchMoviesByKeyword(keyword: keyword) { movies in
            self.movies = movies.results ?? []
            DispatchQueue.main.async {
                self.searchTableView.reloadData()
            }
        }
    }
}//class

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as? MovieTableViewCell else { return UITableViewCell() }
        
        let movie = movies[indexPath.row]
        cell.titleLabel.text = movie.title
        cell.overviewLabel.text = Constants.Icon.overview + (movie.overview != "" ? movie.overview! : "Plot unknown")
        if movie.voteAverage != 0.0 {
            cell.ratingLabel.isHidden = false
            cell.ratingLabel.text = Constants.Icon.rating + movie.voteAverage.stringValue
        }else{
            cell.ratingLabel.isHidden = true
        }
        
        if movie.releaseDate != "" {
            cell.releaseDateLabel.isHidden = false
            cell.releaseDateLabel.text = Constants.Icon.releaseDate + movie.releaseDate.longDateString
        }else{
            cell.releaseDateLabel.isHidden = true
        }
        if let poster = movie.posterPath {
            cell.posterImageView.sd_setImage(with: URL(string: Constants.API.posterUrl.appending(poster)))
        }else{
            cell.posterImageView.sd_setImage(with: URL(string: Constants.Image.posterPlaceholder))
        }
        cell.selectionStyle = .none
        
        return cell
    }//cellForRowAt
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.RowHeight.searchTableViewCell
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
        vc.movieId = "\(movie.id ?? 0)"
        
        navigationController?.pushViewController(vc, animated: true)
    }//didSelectRowAt
}
