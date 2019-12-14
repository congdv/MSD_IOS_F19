//
//  ViewController.swift
//  Week_10_Lab_6
//
//  Created by Student on 2019-11-08.
//  Copyright © 2019 Student. All rights reserved.
//

import UIKit
import CoreLocation

struct Wind : Codable {
    let speed : Float
    let deg: Float
}

struct Main : Codable{
    let temp : Float
    let pressure: Float
    let humidity: Float
    let temp_min: Float
    let temp_max: Float
}

struct Coord:Codable {
    let lon: Float
    let lat: Float
}
struct Weather: Codable{
    let id: Int
    let main: String
    let description: String
    let icon: String
    
}
struct Wdata : Codable{
    let name : String
    let id: Int
    let coord: Coord
    let weather : [Weather]
    let main: Main
    let wind: Wind
    
}

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let UrlString = "https://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&appid=949870bb6ad9cc5e653801934dc184f4&units=metric"
    
    var locationManager = CLLocationManager()
    
    var latitude: Double = 0
    var longitude: Double = 0
    
    
    @IBOutlet weak var lblCityName: UILabel!
    @IBOutlet weak var lblWeatherDesc: UILabel!
    @IBOutlet weak var ivWeather: UIImageView!
    @IBOutlet weak var lblCurrentTemperature: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!
    @IBOutlet weak var lblWind: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    func renderingTheView(_ wData: Wdata) {
        self.lblCityName.text = String(wData.name)
        self.lblCurrentTemperature.text = String(Int(wData.main.temp.rounded())) + " °C"
        self.lblHumidity.text = "Humidity: "+String(Int(wData.main.humidity.rounded()))+"%"
        self.lblWind.text = "Wind: " + String(Int((wData.wind.speed * 3.6).rounded())) + " km/h"
        self.lblWeatherDesc.text = String(wData.weather[0].description)
        self.ivWeather.image = UIImage(named: wData.weather[0].icon)
    }
    
    func updatingCurrentWeather() {
        let urlSession = URLSession(configuration: .default)
        
        if let url = URL(string: String(format: UrlString, latitude,longitude)){
            let task = urlSession.dataTask(with: url) {
                (data, response, error ) in
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let wData = try decoder.decode(Wdata.self, from: data)
                        print(wData.name)
                        DispatchQueue.main.async {
                            self.renderingTheView(wData)
                        }
                    } catch {
                        print(error)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        
        updatingCurrentWeather()
    }


}

