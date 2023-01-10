//
//  API.swift
//  SimpleWeather
//
//  Created by Sandor Gyulai on 10/01/2023.
//

import Foundation
import Alamofire
import Combine

struct API {

    enum Endpoint: String {
        case weather
        case forecast
    }

    enum APIError: Error {
        case invalidURL
        case networkError(error: AFError)
    }

    static let shared = API()

    private let baseURL = URL(string: "https://api.openweathermap.org/data/2.5/")
    private let apiKey = "API_KEY_HERE"
    private let session: Session

    init() {
        let configuration = URLSessionConfiguration.default
        session = Session(configuration: configuration)
    }

    func getData<T: Codable>(from endpoint: Endpoint, with parameters: Parameters? = nil) -> AnyPublisher<T, APIError> {

        guard let url = URL(string: endpoint.rawValue, relativeTo: baseURL) else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970

        var params = parameters
        params?["appid"] = apiKey

        return session.request(url, method: .get, parameters: params)
            .publishDecodable(type: T.self, decoder: decoder)
            .value()
            .mapError { APIError.networkError(error: $0) }
            .eraseToAnyPublisher()
    }

}
