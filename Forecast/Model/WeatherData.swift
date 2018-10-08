//
//  WeatherData.swift
//  Forecast
//
//  Created by Hector Mendoza on 10/8/18.
//  Copyright © 2018 Mirlintox. All rights reserved.
//

import Foundation

class WeatherData {
    var cityName: String = ""
    var cityTemperature: Double = 0
    var isFahreinheit: Bool = false
    var condition: Int = 0
    var weatherIconName: String = ""
    
    let weekdays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    var currentDayNum = 0
    var daysForecast: [String] = []
    
    var minTempForecast: [Double] = []
    var maxTempForecast: [Double] = []
    var conditionForecast: [Int] = []
    var weatherIconNameForecast: [String] = []
    
    func updateWeatherIcon(condition: Int) -> String {
        switch (condition) {
            
        case 0...300 :
            return "tstorm1"
            
        case 301...500 :
            return "light_rain"
            
        case 501...600 :
            return "shower3"
            
        case 601...700 :
            return "snow4"
            
        case 701...771 :
            return "fog"
            
        case 772...799 :
            return "tstorm3"
            
        case 800 :
            return "sunny"
            
        case 801...804 :
            return "cloudy2"
            
        case 900...903, 905...1000  :
            return "tstorm3"
            
        case 903 :
            return "snow5"
            
        case 904 :
            return "sunny"
            
        default :
            return "dunno"
        }
    }
}
