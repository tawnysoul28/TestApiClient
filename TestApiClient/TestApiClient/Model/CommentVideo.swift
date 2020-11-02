//
//  CommentVideo.swift
//  TestApiClient
//
//  Created by Bob on 02.11.2020.
//  Copyright © 2020 Bob. All rights reserved.
//

import Foundation

struct CommentVideo: Decodable {
    let nextPageToken: String?
    let items: [CommentItem]?
}

struct CommentItem: Decodable {
    let snippet: CommentSnippet?
}

struct CommentSnippet: Decodable {
    let topLevelComment: TopLevelComment?
}

struct TopLevelComment: Decodable {
    let snippet: Comment?
}

struct Comment: Decodable {
    let authorDisplayName: String
    let textDisplay: String
}
