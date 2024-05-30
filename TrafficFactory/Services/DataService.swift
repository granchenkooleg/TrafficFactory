//
//  DataService.swift
//  TrafficFactory
//
//  Created by Oleg Granchenko on 29.05.2024.
//

import Foundation
import Combine

class DataService {
    static let shared = DataService()

    private init() {}

    func fetch<T: Decodable>(forResource resource: String, withExtension ext: String) -> AnyPublisher<[T], Error> {
        guard let url = Bundle.main.url(forResource: resource, withExtension: ext) else {
            return Fail(error: URLError(.fileDoesNotExist))
                .eraseToAnyPublisher()
        }

        do {
            let data = try Data(contentsOf: url)
            let items = try JSONDecoder().decode([T].self, from: data)
            return Just(items)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
}


