//
//  StatisticVideo.swift
//  TestApiClient
//
//  Created by Bob on 01.11.2020.
//  Copyright © 2020 Bob. All rights reserved.
//

import Foundation

struct StatisticVideo: Decodable {
    let items: [ItemVideo]?
}

struct ItemVideo: Decodable {
    let id: String?
    let snippet: SnippetVideo?
    let contentDetails: ContentDetails?
    let statistics: Statistics?
}

struct SnippetVideo: Decodable {
    let publishedAt: String?
    let channelId: String?
    let title: String?
    let description: String?
    let channelTitle: String?
    let tags: [String]?
}

struct ContentDetails: Decodable {
    let duration: String?
}

struct Statistics: Decodable {
    let viewCount: String?
    let likeCount: String?
    let dislikeCount: String?
}
