//
//  DetailVC.swift
//  TestApiClient
//
//  Created by Bob on 31.10.2020.
//  Copyright © 2020 Bob. All rights reserved.
//

import UIKit
import WebKit

class DetailVC: UIViewController {

	//MARK: - IB Outlets
	@IBOutlet weak var titleLable: UILabel!
	@IBOutlet weak var webView: WKWebView!
	@IBOutlet weak var descriptionTextView: UITextView!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var tableViewComments: UITableView!

	// MARK: - Propertes
	private let datafetcherService = DataFetcherService()
	private let cellId = "commentCell"
	private var comments: [CommentItem]?
    private var nextPageToken: String?
    private var fetchingMore = false
	var currentVideo: Item?

	override func viewDidLoad() {
        super.viewDidLoad()
		setupDetailVC()
    }

	private func setupDetailVC() {

		self.tableViewComments.delegate = self
		self.tableViewComments.dataSource = self

		activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true

        descriptionTextView.isEditable = false

		if let id = self.currentVideo?.id?.videoId {

			self.datafetcherService.fecthStatistic(id: id) { [weak self] (result) in
				guard let self = self else { return }
				switch result {
					case .success(let statistic):
					DispatchQueue.main.async {
						let snippet = statistic?.items?.first?.snippet
						let duration = statistic?.items?.first?.contentDetails?.duration

						// Title
						self.titleLable.text = snippet?.title ?? ""

						// WebView
						let stringUrl = "\(Constants.playerUrl)\(id)"
						let videoURL = URL(string: stringUrl)
						self.webView.load(URLRequest(url: videoURL!))
						self.activityIndicator.stopAnimating()

						// Description
						self.descriptionTextView.text = """
						Channel: \(snippet?.channelTitle ?? "")
						Link: https://www.youtube.com/channel/\(snippet?.channelId ?? "")

						View count: \(statistic?.items?.first?.statistics?.viewCount ?? "0")
						Like count: \(statistic?.items?.first?.statistics?.likeCount ?? "0")
						Dislike count: \(statistic?.items?.first?.statistics?.dislikeCount ?? "0")

						Published: \(snippet?.publishedAt ?? "")
						Duration: \(duration ?? "")

						Description: \(snippet?.description ?? "")

						Tags: \(snippet?.tags?.joined(separator: ", ") ?? "")
						"""
					}
					case .failure(let error):
						print(error.localizedDescription)
					}
			}

			self.datafetcherService.fetchComments(id: id, pageToken: nextPageToken) { [weak self] result in
				guard let self = self else { return }
				switch result {
					case .success(let comments):
						if let commentsItem = comments?.items {
							self.comments = commentsItem
							DispatchQueue.main.async {
								self.tableViewComments.reloadData()
							}
						}

						if let nextToken = comments?.nextPageToken {
							self.nextPageToken = nextToken
						}
					case .failure(let error):
					print(error.localizedDescription)
				}
			}
		}
	}
}

extension DetailVC: UITableViewDataSource, UITableViewDelegate {
	// MARK: - Table view data source
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		comments?.count ?? 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! DetailCell
		let comment = comments![indexPath.row]
		cell.configureCell(for: comment)
		return cell
	}

	// отлавливаем скролл чтобы подгрузить комментарии через nextToken
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height - scrollView.frame.height

        if offsetY > contentHeight {
            if !fetchingMore {
                beginUpdate()
            }
        }
    }

	func beginUpdate() {
        fetchingMore = true

        guard let nextToken = nextPageToken else { return }
		if let id = self.currentVideo?.id?.videoId {

			datafetcherService.fetchComments(id: id, pageToken: nextToken) { [weak self] result in
				guard let self = self else { return }
				switch result {
					case .success(let nextComments):
					if let nextPageToken = nextComments?.nextPageToken {
                        self.nextPageToken = nextPageToken
                    } else {
                        self.nextPageToken = nil
                    }
                    if let items = nextComments?.items {
                        for item in items {
                            self.comments?.append(item)
                        }
						DispatchQueue.main.async {
							self.tableViewComments.reloadData()
						}
                    }
                    self.fetchingMore = false
					DispatchQueue.main.async {
						self.tableViewComments.reloadData()
					}
					case .failure(let error):
					print(error.localizedDescription)
				}
			}
        }
    }

}
