//
//  DetailViewController.swift
//  flix_demo
//
//  Created by Amzad Chowdhury on 9/17/18.
//  Copyright © 2018 Amzad Chowdhury. All rights reserved.
//

import UIKit
enum MovieKeys {
    static let title = "title"
    static let releaseDate = "release_date"
    static let overview = "overview"
    static let backdropPath = "backdrop_path"
    static let posterPath = "poster_path"
    static let movieID = "id"
}

class DetailViewController: UIViewController {

    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backDropImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewField: UITextView!
    
    var movie: [String: Any]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let movie = movie {
            titleLabel.text = movie[MovieKeys.title] as? String
            releaseDateLabel.text = movie[MovieKeys.releaseDate] as? String
            overviewField.text = movie[MovieKeys.overview] as? String
            //overviewLabel.sizeToFit()
            
            let backdropPathString = movie[MovieKeys.backdropPath] as! String
            let posterPathString = movie[MovieKeys.posterPath] as! String
            let baseURLString = "https://image.tmdb.org/t/p/w500/"
            
            let backDropURL = URL(string: baseURLString + backdropPathString)!
            backDropImageView.af_setImage(withURL: backDropURL)
            
            let posterURL = URL(string: baseURLString + posterPathString)!
            posterImageView.af_setImage(withURL: posterURL)
            posterImageView.layer.borderWidth = 2
            navigationItem.title = movie[MovieKeys.title] as? String
            
        
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let movieTrailerViewController = segue.destination as! MovieTrailerViewController
            movieTrailerViewController.movieID = (movie![MovieKeys.movieID] as? Int)!

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
