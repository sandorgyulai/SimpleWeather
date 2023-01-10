//
//  Main.swift
//  SimpleWeather
//
//  Created by Sandor Gyulai on 10/01/2023.
//

import Foundation

struct Temperature: Codable, Hashable {
    let temp: Double
}

extension Double {
    var asInt: Int {
        Int(self.rounded())
    }
}
