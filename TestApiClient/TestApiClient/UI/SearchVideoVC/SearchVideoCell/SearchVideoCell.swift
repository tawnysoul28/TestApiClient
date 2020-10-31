//
//  SearchVideoCell.swift
//  TestApiClient
//
//  Created by Bob on 30.10.2020.
//  Copyright © 2020 Bob. All rights reserved.
//

import UIKit

class SearchVideoCell: UITableViewCell {

	@IBOutlet weak var videoImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!

	private var datafetcherService = DataFetcherService()

	func configureCell(for item: Item) {

		datafetcherService.fetchImage(with: item.snippet.thumbnails.high.url) { [weak self] result in
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
		
		titleLabel.text = item.snippet.title
		descriptionLabel.text = item.snippet.description
	}

}
