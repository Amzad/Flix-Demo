//
//  MovieTrailerViewController.swift
//  flix_demo
//
//  Created by Amzad Chowdhury on 9/17/18.
//  Copyright © 2018 Amzad Chowdhury. All rights reserved.
//

import UIKit

class MovieTrailerViewController: UIViewController {

    var movieID:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let baseURLString = "https://api.themoviedb.org/3/movie/"
        let postURL = (String(movieID) + "/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US")
        let videoURL = (baseURLString + postURL)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
