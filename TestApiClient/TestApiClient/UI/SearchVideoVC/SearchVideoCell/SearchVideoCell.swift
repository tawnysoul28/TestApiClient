//
//  SearchVideoCell.swift
//  TestApiClient
//
//  Created by Bob on 30.10.2020.
//  Copyright © 2020 Bob. All rights reserved.
//

import UIKit

class SearchVideoCell: UITableViewCell {

	//MARK: - IB Outlets
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var videoImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!

	private var datafetcherService = DataFetcherService()

	// MARK: - Life Cycle
   override func awakeFromNib() {
	   super.awakeFromNib()
	   activityIndicator.startAnimating()
	   activityIndicator.hidesWhenStopped = true
   }

	func configureCell(for item: Item) {

		datafetcherService.fetchImage(with: item.snippet?.thumbnails?.default?.url ?? "") { [weak self] result in
			guard let self = self else { return }
			switch result {
				case .success(let image):
					DispatchQueue.main.async {
						self.videoImageView.image = image
				}
				case .failure(let error):
					print(error.localizedDescription)
			}
		}
		
		titleLabel.text = item.snippet?.title
		descriptionLabel.text = "\(item.snippet?.channelTitle ?? "")\n\(item.snippet?.description ?? "")"
	}

}
