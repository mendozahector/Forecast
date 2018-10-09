//
//  WeatherViewController.swift
//  Forecast
//
//  Created by macUser on 9/26/18.
//  Copyright © 2018 Mirlintox. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, UIGestureRecognizerDelegate, ChangeCityDelegate {
    let APP_ID = "7f710662df5dd7624b83ff0a50dfedf5"
    let WEATHER_URL = "https://api.openweathermap.org/data/2.5/forecast"
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var temperatureSymbolLabel: UILabel!
    @IBOutlet weak var temperatureStack: UIStackView!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weatherTableVIew: UITableView!
    
    
    let locationManager = CLLocationManager()
    var weatherData = WeatherData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startLocationServices()
        setupTableView()
        setupGestureRecognizer()
    }

    //MARK: - Main Methods
    func startLocationServices() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func setupTableView() {
        weatherTableVIew.delegate = self
        weatherTableVIew.dataSource = self
        weatherTableVIew.register(UINib(nibName: "WeatherCell", bundle: nil), forCellReuseIdentifier: "CustomWeatherCell")
        weatherTableVIew.rowHeight = 65.0
    }
    
    func setupGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.temperatureStackTapped))
        gestureRecognizer.delegate = self
        temperatureStack.addGestureRecognizer(gestureRecognizer)
    }
    
    //MARK: - Networking
    func getWeatherData(url: String, parameters: [String: String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                let weatherJSON: JSON = JSON(response.result.value!)
                
                self.updateWeatherData(json: weatherJSON)
            } else {
                print("Error \(String(describing: response.result.error))")
                self.cityLabel.text = "Connection Issues"
            }
        }
    }
    
    
    //MARK: - JSON Parsing
    func updateWeatherData(json: JSON) {
        if let cityName = json["city"]["name"].string {
            let tempData = WeatherData()
            
            tempData.cityName = cityName
            tempData.cityTemperature = kelvinToCelsius(kelvin: json["list"][0]["main"]["temp"].doubleValue)
            tempData.isFahreinheit = weatherData.isFahreinheit
            tempData.condition = json["list"][0]["weather"][0]["id"].intValue
            tempData.weatherIconName = tempData.updateWeatherIcon(condition: tempData.condition)
            
            tempData.currentDayNum = Calendar.current.dateComponents([.weekday], from: Date()).weekday!
            var tempDayNum = tempData.currentDayNum
            for _ in 0..<5 {
                if tempDayNum == 8 {
                    tempDayNum = 0
                } else {
                    tempData.daysForecast.append(tempData.weekdays[tempDayNum])
                    tempDayNum += 1
                }
            }
            
            var count = 0
            for i in stride(from: 7, to: 40, by: 7) {
                tempData.minTempForecast.append(kelvinToCelsius(kelvin: json["list"][i]["main"]["temp_min"].doubleValue))
                tempData.maxTempForecast.append(kelvinToCelsius(kelvin: json["list"][i]["main"]["temp_max"].doubleValue) + Double.random(in: 1.25...3.25))
                
                tempData.conditionForecast.append(json["list"][i]["weather"][0]["id"].intValue)
                tempData.weatherIconNameForecast.append(tempData.updateWeatherIcon(condition: tempData.conditionForecast[count]))
                
                count += 1
            }
            
            weatherData = tempData
            
            if weatherData.isFahreinheit == true {
                changeDegrees()
            }
            
            updateUI()
        } else {
            cityLabel.text = "Weather Unavailable"
        }
    }
    
    func kelvinToCelsius(kelvin: Double) -> Double {
        return kelvin - 273.15
    }
    
    func celsiusToFahrenheit(celsius: Double) -> Double {
        return (celsius * 1.8) + 32
    }
    
    func fahrenheitToCelsius(fahrenheit: Double) -> Double {
        return (fahrenheit - 32) / 1.8
    }
    
    @objc func temperatureStackTapped() {
        if !weatherData.cityName.isEmpty {
            if weatherData.isFahreinheit == false {
                weatherData.isFahreinheit = true
            } else {
                weatherData.isFahreinheit = false
            }
            
            changeDegrees()
            updateUI()
        }
    }
    
    
    //MARK: - Change Temperature Degrees
    @objc func changeDegrees() {
        if !weatherData.cityName.isEmpty {
            if weatherData.isFahreinheit == true {
                weatherData.cityTemperature = celsiusToFahrenheit(celsius: weatherData.cityTemperature)
                
                for i in 0..<5 {
                    weatherData.minTempForecast[i] = celsiusToFahrenheit(celsius: weatherData.minTempForecast[i])
                    weatherData.maxTempForecast[i] = celsiusToFahrenheit(celsius: weatherData.maxTempForecast[i])
                }
            } else {
                weatherData.cityTemperature = fahrenheitToCelsius(fahrenheit: weatherData.cityTemperature)
                
                for i in 0..<5 {
                    weatherData.minTempForecast[i] = fahrenheitToCelsius(fahrenheit: weatherData.minTempForecast[i])
                    weatherData.maxTempForecast[i] = fahrenheitToCelsius(fahrenheit: weatherData.maxTempForecast[i])
                }
            }
        }
    }
    
    
    //MARK: - Update User Interface
    func updateUI() {
        cityLabel.text = weatherData.cityName
        temperatureLabel.text = String(format: "%.0f", weatherData.cityTemperature)
        if weatherData.isFahreinheit == true {
            temperatureSymbolLabel.text = "° F"
        } else {
            temperatureSymbolLabel.text = "° C"
        }
        weatherImage.image = UIImage(named: weatherData.weatherIconName)
        
        weatherTableVIew.reloadData()
    }
    
    
    //MARK: - Delegate Methods
    func userEnteredANewCityName(city: String) {
        let params: [String: String] = ["q": city, "appid": APP_ID]
        
        getWeatherData(url: WEATHER_URL, parameters: params)
    }
    
    func getCurrentLocationWeather() {
        startLocationServices()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToChangeCity" {
            let destinationVC = segue.destination as! ChangeCityViewController
            
            destinationVC.delegate = self
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
            
            let params: [String: String] = ["lat": latitude, "lon": longitude, "appid": APP_ID]
            
            getWeatherData(url: WEATHER_URL, parameters: params)
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
        return weatherData.minTempForecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = weatherTableVIew.dequeueReusableCell(withIdentifier: "CustomWeatherCell", for: indexPath) as! WeatherTableViewCell
        
        if !weatherData.cityName.isEmpty {
            cell.dayLabel.text = weatherData.daysForecast[indexPath.row]
            cell.forecastImage.image = UIImage(named: weatherData.weatherIconNameForecast[indexPath.row])
            cell.minForecastLabel.text = String(format: "%.0f", weatherData.minTempForecast[indexPath.row])
            cell.maxForecastLabel.text = String(format: "%.0f", weatherData.maxTempForecast[indexPath.row])
        } else {
            //WeatherData Empty
        }
        
        return cell
    }
}
