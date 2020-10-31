//
//  NetworkService.swift
//  TestApiClient
//
//  Created by Bob on 30.10.2020.
//  Copyright © 2020 Bob. All rights reserved.
//

import Foundation

protocol Networking {
	func request(url: URL, completion: @escaping (Result<Data, AppError>) -> ())
}

class NetworkService: Networking {

	// построение запроса данных по URL
	func request(url: URL, completion: @escaping (Result<Data, AppError>) -> ()) {
		let request = URLRequest(url: url)
		let task = createDataTask(from: request, completion: completion)
		task.resume()
	}

	private func createDataTask(from request: URLRequest, completion: @escaping (Result<Data, AppError>) -> ()) -> URLSessionTask {
		return URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in

			if let error = error {
				completion(.failure(.networkClientError(error)))
                return
            }

            guard let urlResponse = response as? HTTPURLResponse else {
                completion(.failure(.noResponse))
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            switch urlResponse.statusCode {
            case 200...299: break // everything went well here
            default:
                completion(.failure(.badStatusCode(urlResponse.statusCode)))
                return
            }
                completion(.success(data))
		})
	}
}
