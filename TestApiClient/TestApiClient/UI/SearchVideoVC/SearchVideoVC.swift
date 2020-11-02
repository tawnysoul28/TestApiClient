//
//  SearchVideoVC.swift
//  TestApiClient
//
//  Created by Bob on 30.10.2020.
//  Copyright © 2020 Bob. All rights reserved.
//

import UIKit

class SearchVideoVC: UITableViewController {

	private let activityView = UIActivityIndicatorView(style: .large)
	
	private var videos: [Item] = []
	private var searchText: String = ""

	private let datafetcherService = DataFetcherService()
	private let cellID = "videoCell"

	override func viewDidLoad() {
        super.viewDidLoad()
		setupSearchBar()
        setupRefreshControl()
    }

	private func showActivityIndicator() {
		DispatchQueue.main.async {
			self.activityView.center = self.view.center
			self.activityView.hidesWhenStopped = true
			self.view.addSubview(self.activityView)
			self.activityView.startAnimating()
		}
    }

	// MARK: - Private methods
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false

        searchController.searchBar.delegate = self
    }

	private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(getVideos), for: .valueChanged)
        tableView.addSubview(refreshControl ?? UIRefreshControl())
    }

	@objc private func getVideos() {
		datafetcherService.fetchVideos(query: searchText) { [weak self] (result) in
			guard let self = self else { return }
			switch result {
				case .success(let videos):
					self.videos = videos?.items ?? []
					DispatchQueue.main.async {
						self.refreshControl?.endRefreshing()
						self.tableView.reloadData()
						self.activityView.stopAnimating()
					}
				case .failure(let error):
					print(error.localizedDescription)
			}
		}
	}

}

extension SearchVideoVC {
	// MARK: - Table view data source
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		videos.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! SearchVideoCell
		let video = videos[indexPath.row]
		cell.configureCell(for: video)
		return cell
	}

	// MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showDetail" else { return }

        if let indexPath = tableView.indexPathForSelectedRow {
            guard let detailVC = segue.destination as? DetailVC else { return }
			let currentVideo = videos[indexPath.row]
			detailVC.currentVideo = currentVideo
        }
    }

}

// MARK: - UISearchBarDelegate
extension SearchVideoVC: UISearchBarDelegate {

	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		showActivityIndicator()
		getVideos()
	}
}
