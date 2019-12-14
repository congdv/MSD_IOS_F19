//
//  DetailViewController.swift
//  Assignment_2
//
//  Created by Student on 2019-12-06.
//  Copyright © 2019 Student. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var detailWeather : WeatherDay?
    
    @IBOutlet weak var lblDayOfWeek: UILabel!
    @IBOutlet weak var lblWeather: UILabel!
    @IBOutlet weak var lblWeatherIcon: UIImageView!
    @IBOutlet weak var lblDegree: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
     
        // Do any additional setup after loading the view.
        displayDetailInformation()
    }
    
    func displayDetailInformation() {
        if let detailWeather = detailWeather {
            lblDayOfWeek.text! = detailWeather.dayOfWeek!
            lblDegree.text! = String(format: "%.0f",detailWeather.temperature!) + " °C"
            lblWeatherIcon?.image = UIImage(named: detailWeather.weatherDayImage!)
            lblWeather.text! = detailWeather.weatherDayType!
            weatherDescription.text! = detailWeather.weatherDayDescription!
        }
    }

}
