//
//  DataFetcherService.swift
//  TestApiClient
//
//  Created by Bob on 30.10.2020.
//  Copyright © 2020 Bob. All rights reserved.
//

import UIKit

class DataFetcherService {

	var dataFetcher: DataFetcher
	init(dataFetcher: DataFetcher = NetworkDataFetcher()) {
		self.dataFetcher = dataFetcher
	}

	// MARK: – Фетчим видео
	func fetchVideos(query: String, completion: @escaping (Result<SearchVideo?,AppError>) -> ()) {

		let queryItems = [
			NSURLQueryItem(name: "key", value: Constants.apiKey),
            NSURLQueryItem(name: "part", value: "snippet"),
            NSURLQueryItem(name: "maxResults", value: "20"),
            NSURLQueryItem(name: "type", value: "video"),
            NSURLQueryItem(name: "q", value: query),
        ]

		let urlComps = NSURLComponents(string: Constants.baseUrl + "/search")!
        urlComps.queryItems = queryItems as [URLQueryItem]
        let url = urlComps.url!

		dataFetcher.fetchGenericJSONData(url: url, response: completion)
	}

	// MARK: - Фетчим заставку

	func fetchImage(with urlString: String, completion: @escaping (Result<UIImage?, AppError>) -> ()) {

		guard let url = URL(string: urlString) else {
            completion(.failure(.badURL(urlString)))
            return
        }

		dataFetcher.fetchImage(url: url, response: completion)
	}

	// MARK: - Фетчим статистику

	func fecthStatistic(id: String, completion: @escaping (Result<StatisticVideo?, AppError>) -> ()) {

		let queryItems = [
			NSURLQueryItem(name: "key", value: Constants.apiKey),
            NSURLQueryItem(name: "part", value: "snippet,contentDetails,statistics,status"),
            NSURLQueryItem(name: "id", value: id)
        ]

		let urlComps = NSURLComponents(string: Constants.baseUrl + "/videos")!
        urlComps.queryItems = queryItems as [URLQueryItem]
        let url = urlComps.url!

		dataFetcher.fetchGenericJSONData(url: url, response: completion)
	}

	// MARK: - Фетчим комменты
	func fetchComments(id: String, pageToken: String?, completion: @escaping (Result<CommentVideo?, AppError>) -> ()) {

		let queryItems = [
            NSURLQueryItem(name: "key", value: Constants.apiKey),
            NSURLQueryItem(name: "textFormat", value: "plaintext"),
            NSURLQueryItem(name: "part", value: "snippet"),
            NSURLQueryItem(name: "videoId", value: id),
            NSURLQueryItem(name: "maxResults", value: "10"),
            NSURLQueryItem(name: "pageToken", value: pageToken ?? ""),
        ]

        let urlComps = NSURLComponents(string: Constants.baseUrl + "/commentThreads")!
        urlComps.queryItems = queryItems as [URLQueryItem]
        let url = urlComps.url!

		dataFetcher.fetchGenericJSONData(url: url, response: completion)
	}
}

