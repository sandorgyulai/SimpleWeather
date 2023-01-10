//
//  WeatherData.swift
//  SimpleWeather
//
//  Created by Sandor Gyulai on 10/01/2023.
//

import SwiftUI
import Combine
import CoreLocation
import Alamofire

class WeatherData: ObservableObject {

    @Published var currentForecast: Forecast?
    @Published var weeklyForecasts: [[Forecast]] = []

    private var currentLocation: CLLocationCoordinate2D?
    private var authorization: CLAuthorizationStatus? {
        didSet {
            checkAuthorization()
        }
    }

    private var cancellables: Set<AnyCancellable> = []

    init() {
        loadLastData()
        checkAuthorization()
        LocationManager.shared.authorizationChangedPublisher.sink { [weak self] in self?.authorization = $0 }
            .store(in: &cancellables)

        LocationManager.shared.locationPublisher.sink { [weak self] location in
            self?.currentLocation = location.coordinate
            self?.getForecastForCurrentLocation()
        }.store(in: &cancellables)
    }

    private func checkAuthorization() {
        guard let authorization else {
            return
        }

        switch authorization {
        case .notDetermined:
            LocationManager.shared.requestLocationAuthorization()
        case .restricted, .denied:
            setDefaultLocationAndGetWeather()
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            LocationManager.shared.getUserLocation()
        @unknown default:
            setDefaultLocationAndGetWeather()
        }
    }

    private func setDefaultLocationAndGetWeather() {
        currentLocation = CLLocationCoordinate2D(latitude: 51.5011, longitude: -0.1246) //London
        getForecastForCurrentLocation()
    }

    private func getForecastForCurrentLocation() {
        getCurrentWeather()
        getWeeklyForecast()
    }

    private func createParameters() -> [String: Any]? {
        guard let currentLocation else {
            return nil
        }
        return ["units": "metric",
                "lon": currentLocation.longitude,
                "lat": currentLocation.latitude] as [String: Any]
    }

    private func getCurrentWeather() {
        API.shared.getData(from: .weather, with: createParameters())
            .sink(receiveCompletion: { print("--> Completion: \($0)") },
                  receiveValue: { [weak self] in
                self?.currentForecast = $0
                try? self?.saveData()
            })
            .store(in: &cancellables)
    }

    private func getWeeklyForecast() {
        API.shared.getData(from: .forecast, with: createParameters())
            .sink(receiveCompletion: { print("--> Completion: \($0)") },
                  receiveValue: { [weak self] in self?.process(weeklyForecast: $0) })
            .store(in: &cancellables)
    }

    private func process(weeklyForecast: WeeklyForecast) {

        let calendar = Calendar.current

        let data = weeklyForecast.list.filter { calendar.component(.day, from: $0.date) != calendar.component(.day, from: Date()) }

        weeklyForecasts = []

        guard var currentDate = data.first?.date else {
            return
        }

        var currentDay: [Forecast] = []

        for item in data {
            let dayA = calendar.component(.day, from: item.date)
            let dayB = calendar.component(.day, from: currentDate)

            if dayA == dayB {
                currentDay.append(item)
            } else {
                currentDate = item.date
                weeklyForecasts.append(currentDay)
                currentDay = []
            }
        }

        try? saveData()
    }

    // MARK: - Save Data

    private let currentKey = "current_weather"
    private let forecastKey = "weahter_forecast"

    private func loadLastData() {
        guard let file = try? FileHandle(forReadingFrom: try fileURL()),
              let dictionary = try? JSONSerialization.jsonObject(with: file.availableData) as? [String: String],
              let current = dictionary[currentKey],
              let weekly = dictionary[forecastKey] else {
            return
        }
        currentForecast = try? JSONDecoder().decode(Forecast.self, from: Data(base64Encoded: current)!)
        weeklyForecasts = (try? JSONDecoder().decode([[Forecast]].self, from: Data(base64Encoded: weekly)!)) ?? []
    }

    private func saveData() throws {

        guard let current = try? JSONEncoder().encode(currentForecast),
              let weekly = try? JSONEncoder().encode(weeklyForecasts) else {
            return
        }

        let dict = [currentKey: current.base64EncodedString(),
                   forecastKey: weekly.base64EncodedString()]
        let data = try JSONSerialization.data(withJSONObject: dict)
        try data.write(to: try fileURL())
    }

    private func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("weather.json")
    }

}
