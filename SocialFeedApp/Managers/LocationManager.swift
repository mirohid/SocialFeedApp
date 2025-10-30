//
//  LocationManager.swift
//  SocialFeedApp
//
//  Created by Mir Ohid Ali  on 29/10/25.
//

import Foundation
import CoreLocation
import Combine

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var locationName: String = ""
    @Published var lastLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = kCLDistanceFilterNone

    }

    func requestLocation() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

//extension LocationManager: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let loc = locations.first else { return }
//        lastLocation = loc
//        reverseGeocode(loc)
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Location error: \(error.localizedDescription)")
//    }
//
//    private func reverseGeocode(_ location: CLLocation) {
//        CLGeocoder().reverseGeocodeLocation(location) { [weak self] places, error in
//            guard let self = self else { return }
//            if let p = places?.first {
//                var comps: [String] = []
//                if let name = p.name { comps.append(name) }
//                if let city = p.locality { comps.append(city) }
//                if let country = p.country { comps.append(country) }
//                DispatchQueue.main.async {
//                    self.locationName = comps.joined(separator: ", ")
//                }
//            } else {
//                DispatchQueue.main.async {
//                    self.locationName = ""
//                }
//            }
//        }
//    }
//}


// MARK: - Delegate
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
      authorizationStatus = status
      if status == .authorizedWhenInUse || status == .authorizedAlways {
          manager.startUpdatingLocation()
      }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      guard let location = locations.last else { return }
      self.lastLocation = location
      fetchCityAndCountry(from: location)
      manager.stopUpdatingLocation()
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
      print("Location Error:", error.localizedDescription)
  }
  
  // MARK: - Reverse Geocode
  private func fetchCityAndCountry(from location: CLLocation) {
      CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
          if let error = error {
              print("Geocode Error:", error.localizedDescription)
              return
          }
          if let place = placemarks?.first {
              let city = place.locality ?? ""
              let country = place.country ?? ""
              DispatchQueue.main.async {
                  self.locationName = [city, country].filter { !$0.isEmpty }.joined(separator: ", ")
              }
          }
      }
  }
}
