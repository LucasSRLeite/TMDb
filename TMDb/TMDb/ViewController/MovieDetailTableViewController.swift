//
//  MovieDetailTableViewController.swift
//  TMDb
//
//  Created by Lucas dos Santos on 06/12/18.
//  Copyright © 2018 LL. All rights reserved.
//

import UIKit

class MovieDetailTableViewController: UITableViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    
    var movie: Movie!
    
    var moviesService = MoviesService()
    var genresHelper: GenresHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moviesService.errorHandler = self
        
        setupContent()
        loadPosterImage()
    }
    
    func setupContent() {
        navigationItem.title = movie.title
        overviewLabel.text = movie.overview
        releaseDateLabel.text = movie.releaseDate
        genresLabel.text = genresHelper?.formattedGenres(for: movie.genreIDs)
    }
    
    func loadPosterImage() {
        activityIndicator.startAnimating()
        moviesService.requestPosterImage(for: movie) { data in
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator.stopAnimating()
                self?.posterImageView.image = UIImage(data: data)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}

extension MovieDetailTableViewController: ErrorHandler {
    func updateAfterError() {
        activityIndicator.stopAnimating()
    }
}
