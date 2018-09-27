//
//  SuperheroViewController.swift
//  flix_demo
//
//  Created by Amzad Chowdhury on 9/17/18.
//  Copyright © 2018 Amzad Chowdhury. All rights reserved.
//

import UIKit

class SuperheroViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var movies: [[String: Any]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 2
        let cellsPerLine:CGFloat = 2
        let interItemSpacingTotal = layout.minimumInteritemSpacing * (cellsPerLine - 1)
        let cellWidth = collectionView.frame.width / cellsPerLine - interItemSpacingTotal / cellsPerLine
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth * (3/2))

        fetchMovies()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 2
        let cellsPerLine:CGFloat = 2
        let interItemSpacingTotal = layout.minimumInteritemSpacing * (cellsPerLine - 1)
        let cellWidth = collectionView.frame.width / cellsPerLine - interItemSpacingTotal / cellsPerLine
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth * (3/2))
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCell", for: indexPath) as! PosterCell
        let movie = movies[indexPath.item]
        if let posterPathString = movie["poster_path"] as? String {
            let baseURLString = "https://image.tmdb.org/t/p/w500"
            let posterUrl = URL(string: baseURLString + posterPathString)!
            cell.posterImageView.af_setImage(withURL: posterUrl)
        }
        return cell
    }
    func fetchMovies() {
        
        //activityCircle.startAnimating()
        let url = URL(string: "https://api.themoviedb.org/3/movie/297762/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US&page=1")!
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
                //self.filteredMovies = self.movies;
                self.collectionView.reloadData()
                
            }
        }
        
        // End refreshing on success or fail
        //self.refreshControl.endRefreshing()
        //self.activityCircle.stopAnimating()
        task.resume()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UICollectionViewCell
        if let indexPath = collectionView.indexPath(for: cell) {
            let movie = movies[indexPath.row]
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.movie = movie
        }
    }

}
