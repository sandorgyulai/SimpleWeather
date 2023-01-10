//
//  PreviewData.swift
//  SimpleWeather
//
//  Created by Sandor Gyulai on 10/01/2023.
//

import Foundation

struct PreviewForecast {
    static let forecastItem = Forecast(temperature: Temperature(value: 1),
                                       weather: [Weather(id: 200, condition: "Rain", description: "Rain")],
                                       date: Date(),
                                       name: nil)
}
