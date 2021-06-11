//
//  ViewController.swift
//  Conditions
//
//  Created by MAC USER on 09/06/2021.
//

import UIKit
import CoreLocation
import MapKit
class ViewController: UIViewController, NetworkCallDelegate, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    
     
    @IBOutlet weak var tfcity: UITextField!
    @IBOutlet weak var lbcurrenttempmain: UILabel!
    @IBOutlet weak var lbcurrentconditionmain: UILabel!
    @IBOutlet weak var imweathermain: UIImageView!
    @IBOutlet weak var lbcurrentmintemp: UILabel!
    @IBOutlet weak var lbcurrenttemp: UILabel!
    @IBOutlet weak var lbcurrentmaxtemp: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var suggestionview: UIView!
    @IBOutlet weak var lbsuggestion: UILabel!
    
    let locationManager = CLLocationManager()
    private var currentPlace: CLPlacemark?
    private let completer = MKLocalSearchCompleter()
    var latitude=""
    var longitude=""
    var stcity=""
    var networkCall=NetworkCall()
    let CL=Colors()
    let um=UsefullMethods()
    var forcastarray: [WeatherItem] = []
    var currentTheme=""
    var currentTask=""
    var isfirst=true
    var currenttemperature=""
    var minimumtemperature=""
    var maximumtemperature=""
    var currentconditions=""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        currentTheme=um.gettheme()
        if(currentTheme==""){
            currentTheme="FOREST"
            um.savetheme(data: currentTheme)
        }
        tfcity.textColor=UIColor.white
        tfcity.delegate=self
        tfcity.addTarget(
          self,
          action: #selector(textFieldDidChange(_:)),
          for: .editingChanged
        )
        networkCall.delegate=self
        completer.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
      
        if(currentconditions != ""){
            currentTheme=um.gettheme()
            setconditions(condition: currentconditions)
        }
        if(stcity != ""){
            tfcity.text=stcity
            stcity=""
            getcurrent(latitude: latitude, longitude: longitude)
        }
        
        
    }
   
    
    @objc private func textFieldDidChange(_ sender: UITextField) {
        if currentPlace != nil {
          currentPlace = nil
          tfcity.text = ""
        }
        if(!tfcity.hasText){
            if completer.isSearching {
              completer.cancel()
            }
            return
        }
        
        completer.queryFragment = tfcity.text!
    }
    @IBAction func tapsuggestion(_ sender: UITapGestureRecognizer) {
        hideSuggestionView()
        let address = lbsuggestion.text!
        tfcity.text=address
        

            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(address) { (placemarks, error) in
                guard
                    let placemarks = placemarks,
                    let location = placemarks.first?.location
                else {
                    // handle no location found
                    return
                }
                //use location found
                self.longitude="\(location.coordinate.longitude)"
                self.latitude="\(location.coordinate.latitude)"
                self.getcurrent(latitude: self.latitude, longitude: self.longitude)
                
            }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
             print("error:: \(error.localizedDescription)")
        }
    func locationManager(_ manager: CLLocationManager,didChangeAuthorization status: CLAuthorizationStatus) {
      
      guard status == .authorizedWhenInUse else {
        return
      }
        locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager,didUpdateLocations locations: [CLLocation]) {
      guard let firstLocation = locations.first else {
        return
      }

         latitude="\(firstLocation.coordinate.latitude)"
         longitude="\(firstLocation.coordinate.longitude)"
        if(tfcity.text! == "" && currentTask == ""){
            getcurrent(latitude: latitude, longitude: longitude)
        }
     
      CLGeocoder().reverseGeocodeLocation(firstLocation) { places, _ in
       
        guard
          let firstPlace = places?.first
          else {
            return
        }

        // 4
        self.currentPlace = firstPlace
        if(self.tfcity.text! == "" && self.isfirst){
            self.isfirst=false
            self.tfcity.text = firstPlace.name
        }
        
      }
        locationManager.stopUpdatingLocation()
       // locationManager.delegate=nil
        
    }
    private func hideSuggestionView() {
        suggestionview.isHidden=true
    }

    private func showSuggestion(_ suggestion: String) {
        lbsuggestion.text = suggestion
        suggestionview.isHidden=false
    }
    func getcurrent(latitude:String,longitude:String){
        currentTask="current"
        networkCall.fetchcurrentweather(latitude: latitude, longitude: longitude)
    }
    func getforcast(latitude:String,longitude:String){
        currentTask="forcast"
        networkCall.fetchforcast(latitude: latitude, longitude: longitude)
    }
    
    func setconditions(condition:String){
        
        if(condition=="Drizzle" || condition=="Rain" || condition=="Thunderstorm" || condition=="Snow"){
            self.view.backgroundColor=CL.colorRainy
            if(currentTheme=="FOREST"){
                imweathermain.image=UIImage(named: "forest_rainy")
            }else{
                imweathermain.image=UIImage(named: "sea_rainy")
            }
            
        }else if(condition=="Clouds"){
            self.view.backgroundColor=CL.colorCloudy
            if(currentTheme=="FOREST"){
                imweathermain.image=UIImage(named: "forest_cloudy")
            }else{
                imweathermain.image=UIImage(named: "sea_cloudy")
            }
            
        }else if(condition=="Clear"){
            self.view.backgroundColor=CL.colorSunny
            if(currentTheme=="FOREST"){
                imweathermain.image=UIImage(named: "forest_sunny")
            }else{
                imweathermain.image=UIImage(named: "sea_sunnypng")
            }
        }else{
            self.view.backgroundColor=CL.colorSunny
            if(currentTheme=="FOREST"){
                imweathermain.image=UIImage(named: "forest_sunny")
            }else{
                imweathermain.image=UIImage(named: "sea_sunnypng")
            }
        }
    }
    func getdayofweek(timestamp:Double)->String{
        let today = Date(timeIntervalSince1970: timestamp)
        var dayofweek=""
        let day = Calendar.current.dateComponents([.weekday], from: today).weekday
        if (day == 1){
            dayofweek="Sunday"
        }else if(day == 2){
            dayofweek="Monday"
        }else if(day == 3){
            dayofweek="Tuesday"
        }else if(day == 4){
            dayofweek="Wednesday"
        }else if(day == 5){
            dayofweek="Thursday"
        }else if(day == 6){
            dayofweek="Friday"
        }else{
            dayofweek="Saturday"
        }
            
        return dayofweek
    }
    @IBAction func menuPressed(_ sender: UIButton) {
        if(tfcity.text! == ""){
            um.showalerts("Alert", mg: "Please provide a city to save", viewcontroller: self)
        }else{
            var favs=um.getfavourites()
            favs=favs+""+tfcity.text!+"|"+latitude+"|"+longitude+"~"
            
            let alert=UIAlertController(title: "Save", message: "Save \(tfcity.text!) to Favourites?", preferredStyle: .alert)
                       
           let action=UIAlertAction(title: "Yes", style: .default, handler:{ action in
               DispatchQueue.main.async(execute: {
                self.um.savefavourites(data: favs)
               })
               
           })
           let action1=UIAlertAction(title: "No", style: .default, handler:{ action in
               DispatchQueue.main.async(execute: {
                   
                  
                   
               })
               
           })
           
           
           alert.addAction(action)
           alert.addAction(action1)
           
           self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func refreshPressed(_ sender: UIButton) {
        suggestionview.isHidden=true
        if(tfcity.text! == ""){
            locationManager.startUpdatingLocation()
        }
        getcurrent(latitude: latitude, longitude: longitude)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.forcastarray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 42
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath) as! ForcastCell
        
         let forcastitem = forcastarray[indexPath.row]
         cell.lbtemp.text = forcastitem.current
        cell.lbdayofweek.text=forcastitem.dayofweek
         let condition=forcastitem.description
        
        if(condition=="Drizzle" || condition=="Rain" || condition=="Thunderstorm" || condition=="Snow"){
            cell.imweather.image=UIImage(named: "rain")
            
        }else if(condition=="Clouds"){
            cell.imweather.image=UIImage(named: "partlysunny")
            
        }else if(condition=="Clear"){
            cell.imweather.image=UIImage(named: "clear")
        }else{
            cell.imweather.image=UIImage(named: "clear")
        }
        return cell
    }
    func serviceCallResponse(ResultFromServer: Dictionary<String, Any>) {
        if(currentTask=="current"){
            
            let currentdetails = ResultFromServer["list"] as! [Dictionary<String, Any>]
            if currentdetails.count > 0 {
                
                for i in 0..<currentdetails.count {
                    let item = currentdetails[i] as! Dictionary<String, Any>
                    let mainitem = item["main"] as! Dictionary<String, Any>
                    let currenttemp = mainitem["temp"] as! NSNumber
                    let mintemp = mainitem["temp_min"] as! NSNumber
                    let maxtemp = mainitem["temp_max"] as! NSNumber
                    let weatheritemarray = item["weather"] as! [Dictionary<String, Any>]
                    let weatheritem = weatheritemarray[0] as! Dictionary<String, Any>
                    let condition = weatheritem["main"] as! String
                    
                    currenttemperature="\(currenttemp)°"
                    minimumtemperature="\(mintemp)°"
                    maximumtemperature="\(maxtemp)°"
                    currentconditions=condition
                    
                }
                lbcurrenttempmain.text=currenttemperature
                lbcurrentconditionmain.text=currentconditions
                lbcurrenttemp.text=currenttemperature
                lbcurrentmintemp.text=minimumtemperature
                lbcurrentmaxtemp.text=maximumtemperature
                
                setconditions(condition: currentconditions)
                
                

            }

            getforcast(latitude: latitude, longitude: longitude)
            
        }else if(currentTask=="forcast"){
            
            if let dailydetails = ResultFromServer["daily"] as? [Dictionary<String, Any>]{
            if dailydetails.count > 0 {
               
                forcastarray.removeAll()
                for i in 0..<dailydetails.count {
                    if(i>5){
                        break
                    }
                    let item = dailydetails[i] as! Dictionary<String, Any>
                    let tempitem = item["temp"] as! Dictionary<String, Any>
                    let daytemp = tempitem["day"] as! NSNumber
                    let datetime = item["dt"] as! Double
                    let weatheritemarray = item["weather"] as! [Dictionary<String, Any>]
                    let weatheritem = weatheritemarray[0] as! Dictionary<String, Any>
                    let condition = weatheritem["main"] as! String
                    let dayofweek = getdayofweek(timestamp: datetime)
                    if(i>0){
                        forcastarray.append(WeatherItem(description: condition, current: "\(daytemp)°", dayofweek: dayofweek))
                    }
                    
                }
                
                tableView.delegate=self
                tableView.dataSource=self
                tableView.tableFooterView = UIView()
                tableView.reloadData()
            }
                
            }else{
                um.showalerts("Alert", mg: "Forcast unavailable for this area", viewcontroller: self)
            }
            
            
        }
    }
}
struct WeatherItem {
    var description: String
    var current: String
    var dayofweek: String
}
extension ViewController: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    hideSuggestionView()

    if completer.isSearching {
      completer.cancel()
    }

    tfcity = textField
  }
}
extension ViewController: MKLocalSearchCompleterDelegate {
  func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
    guard let firstResult = completer.results.first else {
      return
    }
    
    showSuggestion(firstResult.title)
  }

  func completer(
    _ completer: MKLocalSearchCompleter,
    didFailWithError error: Error
  ) {
    print("Error suggesting a location: \(error.localizedDescription)")
  }
}

