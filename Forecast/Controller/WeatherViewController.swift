//
//  WeatherViewController.swift
//  Forecast
//
//  Created by macUser on 9/26/18.
//  Copyright © 2018 Mirlintox. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    @IBOutlet weak var weatherTableVIew: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToChangeCity" {
            
            print("Preparing to go to goToChangeCity")
        }
    }
}
