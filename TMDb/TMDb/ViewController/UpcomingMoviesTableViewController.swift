//
//  UpcomingMoviesViewController.swift
//  TMDb
//
//  Created by Lucas dos Santos on 05/12/18.
//  Copyright © 2018 LL. All rights reserved.
//

import UIKit

class UpcomingMoviesTableViewController: UITableViewController {

    @IBOutlet weak var footerActivityIndicator: UIView!
    
    private var arrayUpcomingMovies = [Movie]()
    private var filteredArrayUpcomingMovies = [Movie]()
    
    private var currentPage = 0
    private var isLoading = false
    
    var moviesService = MoviesService()
    var genresHelper = GenresHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moviesService.errorHandler = self
        genresHelper.delegate = self
        
        setupTableView()
        setupNavigationBar()
        loadNextMovies()
    }
    
    // MARK: Setup
    
    func setupTableView() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    // MARK: Load Data
    
    @objc func refreshAction() {
        currentPage = 0
        loadNextMovies()
    }
    
    func loadNextMovies() {
        currentPage += 1
        isLoading = true
        
        tableView.tableFooterView = footerActivityIndicator
        moviesService.requestUpcomingMovies(at: currentPage) { movies in
            self.arrayUpcomingMovies.append(contentsOf: movies)
            DispatchQueue.main.async { [weak self] in
                self?.refreshControl?.endRefreshing()
                self?.tableView.tableFooterView = nil
                self?.tableView.reloadData()
                self?.isLoading = false
            }
        }
    }
    
    // MARK: UIScrollView
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard filteredArrayUpcomingMovies.isEmpty else { return }
        
        if !isLoading {
            let scrollViewHeight = scrollView.frame.size.height
            let scrollContentSizeHeight = scrollView.contentSize.height
            let scrollOffset = scrollView.contentOffset.y
            
            if (scrollOffset + scrollViewHeight >= scrollContentSizeHeight - 50) {
                loadNextMovies()
            }
        }
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MovieDetailTableViewController {
            let selectedRow = tableView.indexPathForSelectedRow?.row ?? 0
            let selectedMovie = filteredArrayUpcomingMovies.isEmpty ? arrayUpcomingMovies[selectedRow] : filteredArrayUpcomingMovies[selectedRow]
            
            destination.movie = selectedMovie
            destination.genresHelper = genresHelper
        }
    }
}

// MARK: - UITableView Methods

extension UpcomingMoviesTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArrayUpcomingMovies.isEmpty ? arrayUpcomingMovies.count : filteredArrayUpcomingMovies.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? UpcomingMoviesTableViewCell else { return }
        
        let movie = filteredArrayUpcomingMovies.isEmpty ? arrayUpcomingMovies[indexPath.row] : filteredArrayUpcomingMovies[indexPath.row]
        
        if movie.backdropPath == nil {
            return
        }
        
        cell.activityIndicator.startAnimating()
        moviesService.requestBackdropImage(for: movie) { imageData in
            DispatchQueue.main.async {
                let visibleRows = tableView.indexPathsForVisibleRows ?? []
                
                if visibleRows.contains(indexPath) {
                    cell.backdropImageView.image = UIImage(data: imageData)
                    cell.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpcomingMoviesCellIdentifier", for: indexPath) as! UpcomingMoviesTableViewCell
        
        let movie = filteredArrayUpcomingMovies.isEmpty ? arrayUpcomingMovies[indexPath.row] : filteredArrayUpcomingMovies[indexPath.row]
        
        cell.backdropImageView.image = nil
        cell.titleLabel.text = movie.title
        cell.releaseDateLabel.text = movie.releaseDate
        cell.genresLabel.text = genresHelper.formattedGenres(for: movie.genreIDs)
        
        return cell
    }
}

// MARK: - UISearchResults

extension UpcomingMoviesTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text?.lowercased() ?? ""
        filteredArrayUpcomingMovies = arrayUpcomingMovies.filter { $0.title.lowercased().contains(text) }
        tableView.reloadSections([0], with: .automatic)
    }
}

// MARK: - GenreHelperDelegate

extension UpcomingMoviesTableViewController: GenresHelperDelegate {
    func didFinishLoadingGenres() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

// MARK: - ErrorHandler

extension UpcomingMoviesTableViewController: ErrorHandler {
    func updateAfterError() {
        refreshControl?.endRefreshing()
        tableView.tableFooterView = nil
    }
}
