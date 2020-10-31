//
//  VideoModel.swift
//  TestApiClient
//
//  Created by Bob on 30.10.2020.
//  Copyright © 2020 Bob. All rights reserved.
//

import Foundation

struct Videos: Decodable {
	let items: [Item]
}

struct Item: Decodable {
	let id: Id
	let snippet: Snippet
}

struct Id: Decodable {
	let videoId: String
}

struct Snippet: Decodable {
	let title: String
	let description: String
	let thumbnails: Thumbnail
}

struct Thumbnail: Decodable {
	let high: High
}

struct High: Decodable {
	let url: String
	let width: Int
	let height: Int
}
