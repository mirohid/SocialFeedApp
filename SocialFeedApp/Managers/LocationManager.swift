//
//  LocationManager.swift
//  SocialFeedApp
//
//  Created by Mir Ohid Ali  on 29/10/25.
//

import Foundation
import CoreLocation
import Combine

final class LocationManager: NSObject, ObservableObject {
    private let manager = CLLocationManager()
    @Published var locationName: String = ""
    @Published var lastLocation: CLLocation?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocation() {
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.first else { return }
        lastLocation = loc
        reverseGeocode(loc)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }

    private func reverseGeocode(_ location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] places, error in
            guard let self = self else { return }
            if let p = places?.first {
                var comps: [String] = []
                if let name = p.name { comps.append(name) }
                if let city = p.locality { comps.append(city) }
                if let country = p.country { comps.append(country) }
                DispatchQueue.main.async {
                    self.locationName = comps.joined(separator: ", ")
                }
            } else {
                DispatchQueue.main.async {
                    self.locationName = ""
                }
            }
        }
    }
}
