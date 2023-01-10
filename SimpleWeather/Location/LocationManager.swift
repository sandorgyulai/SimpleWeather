//
//  LocationManager.swift
//  SimpleWeather
//
//  Created by Sandor Gyulai on 10/01/2023.
//

import Foundation
import Combine
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {

    static let shared = LocationManager()
    private var locationManager: CLLocationManager = CLLocationManager()

    override init() {
        super.init()
        setupLocationManager()
    }

    public func setupLocationManager() {
        locationManager.delegate = self
    }

    public func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }

    public func getUserLocation() {
        locationManager.requestLocation()
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager,
                                didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationEvent.send(status)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard let lastUserLocation = locations.last else {
            return
        }

        print(lastUserLocation)
        locationEvent.send(lastUserLocation)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("--> Error getting user location:\n\(error)")
    }

    // MARK: - Combine

    private var locationEvent = PassthroughSubject<CLLocation, Never>()

    var locationPublisher: AnyPublisher<CLLocation, Never> {
        locationEvent.eraseToAnyPublisher()
    }

    private var authorizationEvent = PassthroughSubject<CLAuthorizationStatus, Never>()

    var authorizationChangedPublisher: AnyPublisher<CLAuthorizationStatus, Never> {
        authorizationEvent.eraseToAnyPublisher()
    }
}
