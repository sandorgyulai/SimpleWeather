//
//  Double+Extensions.swift
//  SimpleWeather
//
//  Created by Sandor Gyulai on 10/01/2023.
//

import Foundation

extension Double {
    var asInt: Int {
        Int(self.rounded())
    }
}
