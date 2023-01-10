//
//  ForecastListItemView.swift
//  SimpleWeather
//
//  Created by Sandor Gyulai on 10/01/2023.
//

import SwiftUI

struct ForecastListItemView: View {

    let forecast: Forecast

    var body: some View {
        VStack(spacing: 8) {
            Text(forecast.time)
                .font(.caption)
            Image(systemName: forecast.weather.first?.imageName ?? "thermometer.medium.slash")
                .frame(width: 32, height: 32)
            Text("\(forecast.temperature.value.asInt)")
                .bold()
        }
    }
}

struct ForecastListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastListItemView(forecast: PreviewForecast.forecastItem)
    }
}
