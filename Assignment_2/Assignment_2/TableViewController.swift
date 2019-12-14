//
//  TableViewController.swift
//  Assignment_2
//
//  Created by Student on 2019-12-04.
//  Copyright © 2019 Student. All rights reserved.
//

import UIKit
import DarkSkyKit
import CoreGraphics
import CoreLocation


class TableViewController: UITableViewController , CLLocationManagerDelegate{

    let token : String = "c5f9d9025cf705efed15d449fce30d8a"
    var weatherDays : [WeatherDay] = [WeatherDay]()
    var locationManager = CLLocationManager()
    
    // Default conestoga location
    var latitude: Double = 0
    var longitude: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        
       
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return weatherDays.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherDayIndentifier", for: indexPath) as! WeatherDayTableViewCell

        let currentItem = weatherDays[indexPath.row]
        
        showCellData(cell:cell, weatherData: currentItem)

        return cell
    }
    
    func showCellData(cell: WeatherDayTableViewCell ,weatherData : WeatherDay) {
        cell.lblDayOfWeek?.text = weatherData.dayOfWeek
        cell.lblDescription?.text = weatherData.weatherDayType
        cell.lblTemperature?.text = String(format: "%.0f", weatherData.temperature!) + " °C"
        let cellImg : UIImageView = UIImageView(frame: CGRect(x:20, y:20,width: 100,height: 100))
        cellImg.image = UIImage(named: weatherData.weatherDayImage!)
        cell.addSubview(cellImg)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         performSegue(withIdentifier: "detailWeatherIdentifier" , sender: weatherDays[indexPath.row])
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let detailWeatherView =  segue.destination as? DetailViewController
        detailWeatherView?.detailWeather = sender as? WeatherDay
    }
    
    
    func getForecast() {
        let configuration = Configuration(token: token, units: .si, exclude: .alerts)
        let weatherApi = DarkSkyKit(configuration: configuration)
        let group = DispatchGroup()
        
        group.enter()
        
        weatherApi.current(latitude: self.latitude, longitude: self.longitude) {
            
            result in
            switch result {
            case .success(let forecast):
                
                if let daily = forecast.daily {
                    self.weatherDays.removeAll()
                    for day in 0...6 {
                        let forecastOfDay = self.getForecastOf(day: daily[day])
                        self.weatherDays.append(forecastOfDay)
                    }
                    
                    group.leave()
                }
            case .failure(let error):
                print(error,"Fetch error")
            }
        }
        group.notify(queue: .main){
            self.tableView.reloadData()
        }
    }
    
    func getForecastOf(day: ForecastDataPoint) -> WeatherDay {
        var weatherDay: WeatherDay = WeatherDay()
        let dayOfWeek = Calendar.current.component(.weekday, from: day.time!)
        weatherDay.dayOfWeek = self.getDayOfWeek(dayOfWeek: dayOfWeek) + "\n" + getFormatDate(day: day.time!)
        weatherDay.weatherDayDescription = day.summary
        weatherDay.weatherDayType = getWeatherMainType(type: day.icon!)
        weatherDay.weatherDayImage = day.icon
        weatherDay.temperature = (day.temperatureMin! + day.temperatureMax!)/2.0
        weatherDay.minTemperature = day.temperatureMin
        weatherDay.maxTemperature = day.temperatureMax
        
        return weatherDay
    }
  
    
    func getFormatDate(day: Date) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "MMM d, yyyy"
        let dateFormat = dateFormatterGet.string(from: day)
        print(dateFormat)
        return dateFormat
    }
    
    func getWeatherMainType(type: String) -> String {
        var mainType = ""
        let weathers = type.split(separator: "-")
        for weather in weathers {
            mainType += weather + " "
        }
        return mainType
    }
    
    func getDayOfWeek(dayOfWeek: Int) -> String {
        switch dayOfWeek {
        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Tuesday"
        case 4:
            return "Wednesday"
        case 5:
            return "Thursday"
        case 6:
            return "Friday"
        case 7:
            return "Saturday"
        default:
            return "Unknown"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let prevLat = latitude
        let prevLong = longitude
        print(prevLong,prevLat,"prev")
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        getForecast()
    }
}
