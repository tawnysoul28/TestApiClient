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
	func fetchVideos(query: String, completion: @escaping (Result<Videos?,AppError>) -> ()) {

		let queryItems = [
			NSURLQueryItem(name: "key", value: Constants.apiKey),
            NSURLQueryItem(name: "part", value: "snippet"),
            NSURLQueryItem(name: "maxResults", value: "3"),
            NSURLQueryItem(name: "type", value: "video"),
            NSURLQueryItem(name: "q", value: query),
        ]

		let urlComps = NSURLComponents(string: Constants.baseUrl + "/search")!
        urlComps.queryItems = queryItems as [URLQueryItem]
        let url = urlComps.url!

		dataFetcher.fetchGenericJSONData(url: url, response: completion)

//		networkService.request(urlString: urlString) { (result) in
//			switch result {
//				case .failure(let error):
//					completion(.failure(error))
//				case .success(let data):
//					do {
//						let teamData = try JSONDecoder().decode(Videos.self, from: data)
//						let teams = teamData.data
//						completion(.success(teams))
//					} catch {
//						completion(.failure(.decodingError(error)))
//				}
//			}
//		}
	}

	// MARK: - Фетчим лого

	func fetchImage(with urlString: String, completion: @escaping (Result<UIImage?, AppError>) -> ()) {

		guard let url = URL(string: urlString) else {
            completion(.failure(.badURL(urlString)))
            return
        }

		dataFetcher.fetchImage(url: url, response: completion)
	}

//	func getImage(url: String, completion: @escaping (Result<UIImage?, Error>) -> ()) {
//
//        guard let url = URL(string: url) else { return }
//
//        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
//            completion(.success(cachedImage))
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//
//            guard let data = data, let image = UIImage(data: data) else {
//                if let error = error {
//                    print(error.localizedDescription)
//                    completion(.failure(error))
//                    return
//                }
//                return
//            }
//
//            imageCache.setObject(image, forKey: url.absoluteString as NSString)
//            completion(.success(image))
//        }.resume()

}

