//
//  DetailCell.swift
//  TestApiClient
//
//  Created by Bob on 31.10.2020.
//  Copyright © 2020 Bob. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {
	//MARK: - IB Outlets
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var commentLabel: UILabel!

	
	func configureCell(for item: CommentItem) {
		self.nameLabel.text = item.snippet?.topLevelComment?.snippet?.authorDisplayName
		self.commentLabel.text = item.snippet?.topLevelComment?.snippet?.textDisplay
	}
}
