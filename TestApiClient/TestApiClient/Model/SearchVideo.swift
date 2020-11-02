//
//  SearchVideo.swift
//  TestApiClient
//
//  Created by Bob on 30.10.2020.
//  Copyright © 2020 Bob. All rights reserved.
//

import Foundation

struct SearchVideo: Decodable {
    let items: [Item]?
}

struct Item: Decodable {
    let id: Id?
    let snippet: Snippet?
}

struct Id: Decodable {
    let videoId: String?
}

struct Snippet: Decodable {
    let title: String?
    let description: String?
    let thumbnails: Thumbnails?
    let channelTitle: String?
}

struct Thumbnails: Decodable {
    let `default`: Preview?
}

struct Preview: Decodable {
    let url: String?
}
