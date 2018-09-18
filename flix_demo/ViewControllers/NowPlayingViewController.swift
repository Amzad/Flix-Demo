//
//  NowPlayingViewController.swift
//  flix_demo
//
//  Created by Amzad Chowdhury on 9/10/18.
//  Copyright © 2018 Amzad Chowdhury. All rights reserved.
//

import UIKit
import AlamofireImage

class NowPlayingViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityCircle: UIActivityIndicatorView!
    
    
    var movies: [[String: Any]] = [];
    var filteredMovies: [[String: Any]] = [];
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        searchBar.delegate = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NowPlayingViewController.didCallToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        fetchMovies()
    }
    
    @objc func didCallToRefresh(_ refreshControl: UIRefreshControl) {
        fetchMovies()
    }
    
    func fetchMovies() {
        activityCircle.startAnimating()
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US&page=1")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                // Show alert for no network connection
                let alertController = UIAlertController(title: "Unable to Connect", message: "No network connection", preferredStyle: .alert)
                let tryAgainAction = UIAlertAction(title: "Try again", style: .default, handler: {
                    (action) in self.fetchMovies()
                })
                alertController.addAction(tryAgainAction)
                self.present(alertController, animated: true) {
                    
                }
                print(error.localizedDescription)
                
            } else if let data = data {
                let DataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

                let movies = DataDictionary["results"] as! [[String: Any]]
                self.movies = movies
                self.filteredMovies = self.movies;
                self.tableView.reloadData()
                
            }
        }
        
        // End refreshing on success or fail
        self.refreshControl.endRefreshing()
        self.activityCircle.stopAnimating()
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let movie = filteredMovies[indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        let backgroundView = UIView() // Background coloor
        backgroundView.backgroundColor = UIColor(red:0.20, green:0.60, blue:0.86, alpha:1.0)
        cell.selectedBackgroundView = backgroundView

        
        if let posterPathString = movie["poster_path"] as? String {
            let placeholderImage = UIImage(named: "placeholder")
            let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
                size: cell.posterView.frame.size,
                radius: 0.0 // Removed rounded corners for the poster
            )
            
            // Urls for poster iamges
            let baseLowResURLString = "https://image.tmdb.org/t/p/w45/"
            let baseHighResURLString = "https://image.tmdb.org/t/p/w500/"
            
            let posterLowURL = URL(string: baseLowResURLString + posterPathString)!
            let posterHighURL = URL(string: baseHighResURLString + posterPathString)!


            cell.posterView.af_setImage(withURL: posterLowURL,
                                        placeholderImage: placeholderImage,
                                        filter: filter,
                                        imageTransition: .crossDissolve(0.2),
                                        runImageTransitionIfCached: false,
                                        completion: { response in
                                            // Replace low res image with high res
                                            cell.posterView.af_setImage(withURL: posterHighURL)
                                        }
            )
            
        }
        else {
            cell.posterView.image = UIImage(named: "stockposter")
        }
        
        return cell
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredMovies = searchText.isEmpty ? movies : movies.filter{ (movie: [String: Any]) -> Bool in
                return (movie["title"] as! String).localizedCaseInsensitiveContains(searchText)
        }
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell) {
        let filteredMovie = movies[indexPath.row]
        let detailViewController = segue.destination as! DetailViewController
            detailViewController.movie = filteredMovie
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
