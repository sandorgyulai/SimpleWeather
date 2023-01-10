//
//  Forecast.swift
//  SimpleWeather
//
//  Created by Sandor Gyulai on 10/01/2023.
//

import Foundation

struct Forecast: Codable, Hashable, Identifiable {

    enum CodingKeys: String, CodingKey {
        case temperature = "main"
        case weather
        case date = "dt"
        case name
    }

    var id: String {
        return date.description
    }

    let temperature: Temperature
    let weather: [Weather]
    let date: Date

    //Optional so it can be reused in WeeklyForecast
    let name: String?

    var day: String {
        let formatter = DateFormatter()
        formatter.locale = .autoupdatingCurrent
        formatter.setLocalizedDateFormatFromTemplate("dd MMMM")
        return formatter.string(from: date)
    }

    var time: String {
        let formatter = DateFormatter()
        formatter.locale = .autoupdatingCurrent
        formatter.setLocalizedDateFormatFromTemplate("HH")
        return formatter.string(from: date)
    }
}
