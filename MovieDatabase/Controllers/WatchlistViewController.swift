//
//  WatchlistViewController.swift
//  MovieDatabase
//
//  Created by jazeps.ivulis on 24/05/2023.
//

import UIKit
import CoreData
import SDWebImage

class WatchlistViewController: UIViewController {
    
    @IBOutlet weak var watchlistTableView: UITableView!
    @IBOutlet weak var emptyWatchlistButton: UIBarButtonItem!
    
    var watchlistMovies: [MovieItems] = []
    var context: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        loadCoreData()
    }
    
    private func setupView() {
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(sender: )))
        view.addGestureRecognizer(longPressRecognizer)
    }
    
    @objc private func longPressed(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            let touchPoint = sender.location(in: watchlistTableView)
            if let indexPath = watchlistTableView.indexPathForRow(at: touchPoint) {
                markAsWatched(indexPath)
            }
        }
    }
    
    func markAsWatched(_ indexPath: IndexPath) {
        let watchedStatus = watchlistMovies[indexPath.row].watched ? "unwatched" : "watched"
        
        let alert = UIAlertController(title: "Mark as \(watchedStatus)?", message: "Do you want to mark this movie as \(watchedStatus)?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            self.watchlistMovies[indexPath.row].watched = !self.watchlistMovies[indexPath.row].watched
            self.saveCoreData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCoreData()
    }
    
    @IBAction func emptyWatchlistTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Empty watchlist", message: "Do you want to delete all movies from your watchlist?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.emptyWatchlist()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    func countMovies() {
        let moviesInTable = String(self.watchlistTableView.numberOfRows(inSection: 0))
        navigationItem.title = "Watchlist(\(moviesInTable))"
    }
    
    func loadCoreData() {
        let request: NSFetchRequest<MovieItems> = MovieItems.fetchRequest()
        do {
            watchlistMovies = try (context?.fetch(request))!
            if watchlistMovies.count == 0 {
                emptyWatchlistButton.isEnabled = false
                watchlistTableView.setEmptyView(title: "You don't have any movies in your watchlist", message: "Your favorited movies will be here")
            }else{
                emptyWatchlistButton.isEnabled = true
                watchlistTableView.restore()
            }
        }catch{
            print(error)
        }
        watchlistTableView.reloadData()
        countMovies()
    }
    
    func saveCoreData() {
        do {
            try context?.save()
        }catch{
            print(error)
        }
        loadCoreData()
    }
    
    func emptyWatchlist() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieItems")
        let entityRequest: NSBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context?.execute(entityRequest)
            basicAlert(title: "Emptied!", message: "All movies has been successfully deleted from your watchlist.")
            saveCoreData()
        }catch{
            print(error)
        }
    }
}

extension WatchlistViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchlistMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "watchlistCell", for: indexPath) as? WatchlistTableViewCell else { return UITableViewCell() }
        
        let movie = watchlistMovies[indexPath.row]
        cell.titleLabel.text = movie.title
        cell.releaseDateLabel.text = Constants.Icon.releaseDate + movie.releaseDate.stringValue
        cell.runtimeLabel.text = Constants.Icon.runtime + movie.runtime.stringValue
        if movie.rating != "0.0" {
            cell.ratingLabel.isHidden = false
            cell.ratingLabel.text = Constants.Icon.rating + movie.rating.stringValue
        }else {
            cell.ratingLabel.isHidden = true
        }
        if let poster = movie.poster {
            cell.posterImageView.sd_setImage(with: URL(string: poster))
        }else{
            cell.posterImageView.sd_setImage(with: URL(string: Constants.Image.posterPlaceholder))
        }
        cell.accessoryType = movie.watched ? .checkmark : .none
        cell.tintColor = .yellow
        
        return cell
    }//cellForRowAt
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.RowHeight.watchlistTableViewCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.5) {
            cell.transform = CGAffineTransform.identity
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this movie from your watchlist?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                let movie = self.watchlistMovies[indexPath.row]
                self.context?.delete(movie)
                self.basicAlert(title: "Deleted!", message: "Movie has been successfully deleted from your watchlist.")
                self.saveCoreData()
            }))
            self.present(alert, animated: true)
        }
    }//commit delete
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController else { return }
        
        let movie = watchlistMovies[indexPath.row]
        vc.movieId = movie.id ?? ""
        
        navigationController?.pushViewController(vc, animated: true)
    }//didSelectRowAt
}
