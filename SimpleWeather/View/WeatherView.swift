//
//  WeatherView.swift
//  SimpleWeather
//
//  Created by Sandor Gyulai on 10/01/2023.
//

import SwiftUI

struct WeatherView: View {

    @StateObject var weatherData = WeatherData()

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image(systemName: weatherData.currentForecast?.weather.first?.imageName ?? "thermometer.medium.slash")
                        .imageScale(.large)
                        .font(.largeTitle)
                    VStack(spacing: 8) {
                        Text(weatherData.currentForecast?.name ?? "N/A")
                            .font(.caption)
                        Text("\(weatherData.currentForecast?.temperature.value.asInt ?? 0) Cº")
                            .font(.largeTitle.bold())
                        Text(weatherData.currentForecast?.weather.first?.description ?? "N/A")
                    }
                    .padding()
                }
                List(weatherData.weeklyForecasts, id: \.self) { item in
                    VStack(alignment: .leading, spacing: 16) {
                        Text(item.first?.day ?? "N/A")
                            .bold()
                        HStack {
                            ForEach(item) {
                                ForecastListItemView(forecast: $0)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                }

            }
            .navigationTitle("Weather")
            .background(Color(uiColor: .systemGroupedBackground))
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
