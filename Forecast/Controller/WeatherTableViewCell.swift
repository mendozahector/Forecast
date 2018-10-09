//
//  WeatherTableViewCell.swift
//  Forecast
//
//  Created by macUser on 9/26/18.
//  Copyright © 2018 Mirlintox. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet weak var forecastImage: UIImageView!
    @IBOutlet weak var minForecastLabel: UILabel!
    @IBOutlet weak var maxForecastLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
