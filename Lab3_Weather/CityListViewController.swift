//
//  ViewController.swift
//  Lab3_Weather
//
//  Created by Jerry Lee on 12/4/17.
//  Copyright © 2017 Jerry Lee. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import GooglePlacesSearchController

class CityListViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {

    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APPID = "824c7270cebd93216f6a414bc2bcfd9a"
    let GoogleMapsAPIServerKey = "AIzaSyBtE9NgcQCVYBxLcK0O_vZkYBwF4Kk0TnE"
    
    let locationManager = CLLocationManager()
    //let weatherDataModel = WeatherDataModel()
    
    //variable
    var googleSearchController: GooglePlacesSearchController!
    var city : String = ""
    var cityList : [String] = ["San Jose"]
    var cityWeatherDataList = [WeatherDataModel]()
    
    @IBOutlet weak var cityListTableView: UITableView!
    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var cityTempLabel: UILabel!

    @IBAction func getDataButtonClicked(_ sender: Any) {
        
    }
    
    //MARK: Google place search auto complete: the search button connect to here and perform action
    @IBAction func searchAddress(_ sender: UIBarButtonItem) {
        //if you set placetype to geocode, it will return city names only!
        let controller = GooglePlacesSearchController ( apiKey: GoogleMapsAPIServerKey, placeType: PlaceType.geocode)
        
        controller.didSelectGooglePlace { (place) -> Void in
            print(place.description)
            self.city = place.name
            self.cityList.append(self.city)
            //Dismiss Search
            controller.isActive = false
            
            let latitude = String(place.coordinate.latitude)
            let longitude = String(place.coordinate.longitude)
            let params : [String:String] = ["lat": latitude, "lon": longitude, "appid": self.APPID]
            
            self.getWeatherData(url: self.WEATHER_URL, parameters: params)
            self.cityListTableView.reloadData()
        }
        
        
        present(controller, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //getWeatherData(url: WEATHER_URL)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        //ask permission for location and update location
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: Networking - Get data with HTTP
    /*************************************************/
    func getWeatherData(url: String, parameters : [String : String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Get Data Successful")
                let weatherJSON : JSON = JSON(response.result.value!)
                self.updateWeatherDataFromJson(json: weatherJSON)
                
            } else {
                print("Error \(String(describing: response.result.error))")
                self.cityNameLabel.text = "Connection Problem"
            }
        }
    }
    //MARK: JSON Parsing
    /***********************************************/
    func updateWeatherDataFromJson (json: JSON){
        
        if let temp = json["main"]["temp"].double {
            
            let weatherDataModel = WeatherDataModel()
            weatherDataModel.currentTemp = Int(temp - 273.15)
            weatherDataModel.cityName = json["name"].stringValue
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            cityList.append(weatherDataModel.cityName)
            cityWeatherDataList.append(weatherDataModel)
            
            cityNameLabel.text = weatherDataModel.cityName
            cityTempLabel.text = "\(weatherDataModel.currentTemp)°"
            cityListTableView.reloadData()
            //weatherIcon.image = UIImage(named : weatherDataModel.weatherIconName)
            
        } else {
            cityNameLabel.text = "Weather Unavailable"
        }
    }
    
    //MARK: UI update
    func setLabels(weatherData: NSData) {
        
    }
    
    
    
    //MARK: Location manager
    //didUpdateLocations method
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            print("lon =  \(location.coordinate.longitude), lat = \(location.coordinate.latitude)")
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            let params : [String:String] = ["lat": latitude, "lon": longitude, "appid": APPID]
            
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
    }
    //didFailWithError method
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityNameLabel.text = "Location Unavailable"
        
    }
    
    
    
    
    //MARK: Change View
    
    //MARK: Table View Controller
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityWeatherDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityListTableViewCell", for: indexPath) as! CityListTableViewCell
        

        cell.cityNameLabel.text = cityWeatherDataList[indexPath.row].cityName
        cell.cityTempLabel.text = String(cityWeatherDataList[indexPath.row].currentTemp)
        cell.cityWeaterLabel.text = String(cityWeatherDataList[indexPath.row].condition)
        return cell
        
        
    }
    

}

