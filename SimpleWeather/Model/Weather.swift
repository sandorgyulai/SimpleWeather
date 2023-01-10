//
//  Weather.swift
//  SimpleWeather
//
//  Created by Sandor Gyulai on 10/01/2023.
//

import Foundation

struct Weather: Codable, Hashable {

    enum CodingKeys: String, CodingKey {
        case id
        case condition = "main"
        case description
    }

    let id: Int
    let condition: String
    let description: String

    var imageName: String {

        switch id {
        case 200..<300:
            return "cloud.bolt.fill"
        case 300..<400:
            return "cloud.drizzle.fill"
        case 500..<600:
            return "cloud.heavyrain.fill"
        case 600..<700:
            return "cloud.snow.fill"
        case 700..<800:
            return "cloud.fog.fill"
        case 800:
            return "sun.max.fill"
        case 801..<900:
            return "cloud.fill"
        default:
            return "sun.max.fill"
        }
    }
}
