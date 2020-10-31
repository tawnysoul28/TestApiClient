//
//  SearchVideoVC.swift
//  TestApiClient
//
//  Created by Bob on 30.10.2020.
//  Copyright © 2020 Bob. All rights reserved.
//

import UIKit

class SearchVideoVC: UIViewController {

	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var tableView: UITableView!


	let searchController = UISearchController(searchResultsController: nil)
	private let activityView = UIActivityIndicatorView(style: .large)

	var videos = [Item]() {
		didSet {
			print(videos)
		}
	}

	private var datafetcherService = DataFetcherService()
	private let cellID = "videoCell"

	override func viewDidLoad() {
        super.viewDidLoad()
		setupUI()
    }

	private func showActivityIndicator() {
        activityView.center = self.view.center
        activityView.hidesWhenStopped = true
        self.view.addSubview(activityView)
        activityView.startAnimating()
    }

    private func setupUI() {

        // navigation bar
        let navigation = self.navigationController?.navigationBar
        navigation?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigation?.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

        // hide keyboard
        self.tableView.keyboardDismissMode = .onDrag

        // search videos
        searchBar.delegate = self

		// table view
		tableView.delegate = self
		tableView.dataSource = self
    }

}

extension SearchVideoVC: UITableViewDelegate, UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		videos.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! SearchVideoCell
		let video = videos[indexPath.row]
		cell.configureCell(for: video)
		return cell
	}

}

extension SearchVideoVC: UISearchBarDelegate {

	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

		searchBar.resignFirstResponder()

		let searchText = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines)

		guard let text = searchText, searchText != "" else { return }

		showActivityIndicator()

		datafetcherService.fetchVideos(query: text) { [weak self] (result) in
			guard let self = self else { return }
			switch result {
				case .success(let videos):
					for video in videos!.items {
						self.videos.insert(video, at: 0)
					}
					DispatchQueue.main.async {
						self.activityView.stopAnimating()
						self.tableView.reloadData()
					}
				print("fetch videos success")
				case .failure(let error):
					print(error.localizedDescription)
			}
		}
		searchBar.text = ""
	}
}
