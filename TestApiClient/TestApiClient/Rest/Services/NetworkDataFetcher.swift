//
//  NetworkDataFetcher.swift
//  TestApiClient
//
//  Created by Bob on 30.10.2020.
//  Copyright © 2020 Bob. All rights reserved.
//

import UIKit

protocol DataFetcher {
	func fetchGenericJSONData<T: Decodable>(url: URL, response: @escaping (Result<T,AppError>) -> ())

	func fetchImage(url: URL, response: @escaping (Result<UIImage?,AppError>) -> ())
}

class NetworkDataFetcher: DataFetcher {

	private let imageCache = NSCache<NSString, UIImage>()

	var networking: Networking

	init(networking: Networking = NetworkService()) {
		self.networking = networking
	}

	func fetchGenericJSONData<T: Decodable>(url: URL, response: @escaping (Result<T,AppError>) -> ()) {
		print(T.self)
		networking.request(url: url) { (result) in
			switch result {
				case .failure(let error):
					response(.failure(error))
				print("fail decoding")
				case .success(let data):
					let decoded = self.decodeJSON(type: T.self, from: data)
					guard let successDecoded = decoded else { return }
					response(.success(successDecoded))
				print("success decoded")
			}
		}
	}

	func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
		let decoder = JSONDecoder()
		guard let data = from else { return nil }
		do {
			let objects = try decoder.decode(type.self, from: data)
			return objects
		} catch let jsonError {
			print("Failed to decode JSON", jsonError)
			return nil
		}
	}

	func fetchImage(url: URL, response: @escaping (Result<UIImage?, AppError>) -> ()) {

        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            response(.success(cachedImage))
            return
        }

        let request = URLRequest(url: url)

        URLSession.shared.dataTask(with: request) { (data, _, error) in

            guard let data = data, let image = UIImage(data: data) else {
                if let error = error {
                    print(error.localizedDescription)
					response(.failure(.networkClientError(error)))
                    return
                }
                return
            }

			self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
            response(.success(image))
        }.resume()
	}
}
