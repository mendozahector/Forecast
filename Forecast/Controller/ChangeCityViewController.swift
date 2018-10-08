//
//  ChangeCityViewController.swift
//  Forecast
//
//  Created by macUser on 9/26/18.
//  Copyright © 2018 Mirlintox. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

protocol ChangeCityDelegate {
    func userEnteredANewCityName(city: String)
    func getCurrentLocationWeather()
}

class ChangeCityViewController: UIViewController {
    let APP_ID = "7f710662df5dd7624b83ff0a50dfedf5"
    let WEATHER_URL = "https://api.openweathermap.org/data/2.5/forecast"
    var cityList: [String] = []
    var countryList: [String] = []
    
    var delegate: ChangeCityDelegate?
    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var cityListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityListTableView.delegate = self
        cityListTableView.dataSource = self
        cityListTableView.tableFooterView = UIView()
    }
    
    func checkAPICall(url: String, parameters: [String: String], action: String) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                if let cityName = JSON(response.result.value!)["city"]["name"].string {
                    if action == "changeCity" {
                        self.delegate?.userEnteredANewCityName(city: cityName)
                        self.dismissView()
                    } else if action == "addCity" {
                        self.countryList.append(JSON(response.result.value!)["city"]["country"].stringValue)
                        self.cityList.append(cityName)
                        self.cityListTableView.reloadData()
                    }
                } else {
                    print("Invalid City Name")
                }
            } else {
                print("Connection Issues")
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismissView()
    }
    
    @IBAction func changeCityPressed(_ sender: UIButton) {
        let cityName = cityNameTextField.text!
        
        if cityName.isEmpty {
            print("Nothing inside textfield")
        } else {
            let params: [String: String] = ["q": cityName, "appid": APP_ID]
            
            checkAPICall(url: WEATHER_URL, parameters: params, action: "changeCity")
        }
    }
    
    @IBAction func currentLocationPressed(_ sender: Any) {
        delegate?.getCurrentLocationWeather()
        dismissView()
    }
    
    func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addCityPressed(_ sender: UIButton) {
        let cityName = cityNameTextField.text!
        
        if cityName.isEmpty {
            print("Nothing inside textfield")
        } else {
            let params: [String: String] = ["q": cityName, "appid": APP_ID]
            
            checkAPICall(url: WEATHER_URL, parameters: params, action: "addCity")
        }
        
        self.view.endEditing(true)
    }
}




//MARK: - TableView Methods
extension ChangeCityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(cityList.count)
        return cityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cityListTableView.dequeueReusableCell(withIdentifier: "CityListCell", for: indexPath)
        
        cell.textLabel?.text = "\(cityList[indexPath.row]), \(countryList[indexPath.row])"
        cell.textLabel?.textAlignment = .center
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.userEnteredANewCityName(city: cityList[indexPath.row])
        dismissView()
    }
}
