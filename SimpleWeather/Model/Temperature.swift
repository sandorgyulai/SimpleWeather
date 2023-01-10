//
//  Main.swift
//  SimpleWeather
//
//  Created by Sandor Gyulai on 10/01/2023.
//

import Foundation

struct Temperature: Codable, Hashable {

    enum CodingKeys: String, CodingKey {
        case value = "temp"
    }

    let value: Double
}

extension Double {
    var asInt: Int {
        Int(self.rounded())
    }
}
