//
//  WeatherViewController.swift
//  Forecast
//
//  Created by macUser on 9/26/18.
//  Copyright © 2018 Mirlintox. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    let APP_ID = "7f710662df5dd7624b83ff0a50dfedf5"
    let WEATHER_URL = "api.openweathermap.org/data/2.5/forecast"
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weatherTableVIew: UITableView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        weatherTableVIew.delegate = self
        weatherTableVIew.dataSource = self
        weatherTableVIew.register(UINib(nibName: "WeatherCell", bundle: nil), forCellReuseIdentifier: "CustomWeatherCell")
        weatherTableVIew.rowHeight = 65.0
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToChangeCity" {
            
            print("Preparing to go to goToChangeCity")
        }
    }
}




//MARK: - CoreLocation Methods
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            
            locationManager.delegate = nil
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            print("latitude: \(latitude)\nlongitude: \(longitude)")
            
            cityLabel.text = "Location Found"
            
            //let params: [String: String] = ["lat": latitude, "lon": longitude, "appid": APP_ID]
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
}




//MARK: - TableView Methods
extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = weatherTableVIew.dequeueReusableCell(withIdentifier: "CustomWeatherCell", for: indexPath) as! WeatherTableViewCell
        
        cell.dayLabel.text = "Wednesday"
        cell.minForecastLabel.text = "20"
        cell.maxForecastLabel.text = "35"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}
