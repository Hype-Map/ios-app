//
//  MainViewModel.swift
//  Hype Map
//
//  Created by Артем Соловьев on 24.01.2023.
//

import Foundation
import CoreLocation
import MapKit
import Firebase
import SwiftUI

final class MainViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    
    private var didSetUserLocationOnce = false
    
    @Published var lat: Double = 0
    @Published var lon: Double = 0
    
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 0,
            longitude: 0
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 0.03,
            longitudeDelta: 0.03
        )
    )
    
    @Published var locations: [Location] = []
    
    private var userPosition = CLLocationCoordinate2D(
        latitude: 0,
        longitude: 0
    )
    
    private var timer = Timer()
    
    @Published var batterPrecent: Float = 0
    @Published var showLocationButton = true
    @Published var nameCity = ""
    @Published var breathEffect: CGFloat = 1
    @Published var temp: Int = 0
    @Published var iconWeather: String = "clear"
    
    @AppStorage("login_status") var login_status = false
    
    private var apiShared = ApiManager.shared
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.startUpdatingLocation()
        
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        getNameCity()
        getNameCityWithTimeIntervalOfOneSecond()
    }
    
    private func getNameCityWithTimeIntervalOfOneSecond() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.getNameCity()
            self.getWeather()
            withAnimation(.spring()) {
                self.breathEffect = 1.07
            }
        })
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { _ in
            withAnimation(.spring()) {
                self.breathEffect = 1
            }
        })
    }
    
    private func getWeather() {
        apiShared.getWeather(lat: region.center.latitude, lon: region.center.longitude) { weatherModel in
            let icon = weatherModel.weather.last?.main
            DispatchQueue.main.async {
                withAnimation(.spring()) {
                    self.temp = Int(weatherModel.main.temp)
                    
                    if let icon = icon?.lowercased() {
                        self.iconWeather = icon
                    }
                }
            }
        }
    }
    
    private func getNameCity() {
        let location = CLLocation(latitude: region.center.latitude, longitude: region.center.longitude)
        location.fetchCityAndCountry { city, country, error in
            guard let city = city, let _ = country, error == nil else { return }
            withAnimation(.spring()) {
                self.nameCity = city
            }
        }
    }
    
    func goToCurrentLocation() {
        withAnimation(.linear(duration: 0.1)) {
            region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: lat, longitude: lon),
                span: MKCoordinateSpan(latitudeDelta: 0.01,longitudeDelta: 0.01)
            )
        }
    }
    
    //MARK: - Get current user location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.last!
        
        lat = currentLocation.coordinate.latitude
        lon = currentLocation.coordinate.longitude
        
        
        if !didSetUserLocationOnce {
            withAnimation(.spring()) {
                region = MKCoordinateRegion(
                    center: currentLocation.coordinate,
                    span: MKCoordinateSpan(
                        latitudeDelta: 0.03,
                        longitudeDelta: 0.03
                    )
                )
            }
            
            didSetUserLocationOnce = true
        }
        
        userPosition = currentLocation.coordinate
        
        self.locations = [
            Location(name: "me", coordinate: userPosition)
        ]
    }
    
    func logOut() {
        withAnimation(.spring()) {
            login_status = false
        }
    }
}

extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
    }
}
