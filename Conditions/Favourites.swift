//
//  Favourites.swift
//  Conditions
//
//  Created by MAC USER on 11/06/2021.
//

import UIKit
import MapKit
class Favourites: UIViewController, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    let um=UsefullMethods()
    var favsarray: [FavItem] = []
    var stfavs=""
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        stfavs=um.getfavourites()
        if stfavs=="" {
            um.showalerts("Alert", mg: "No saved favourites. Click the + next to the location on weather page to save favourite", viewcontroller: self)
        }else{
            
            loadFavData()
        }
        
    }
   
    func loadFavData(){
        favsarray.removeAll()
        var fav=stfavs.components(separatedBy: "~")
        print("favs:\(fav)")
        for i in 0..<fav.count {
            let favitem=fav[i]
            if(favitem != ""){
                let item=favitem.components(separatedBy: "|")
                let location=item[0]
                let latitude=item[1]
                let longitude=item[2]
            
                favsarray.append(FavItem(description: favitem, city: location, latitude: latitude, longitude: longitude))
                
            }
        }
        
        tableView.delegate=self
        tableView.dataSource=self
        tableView.tableFooterView = UIView()
        tableView.reloadData()
        
        setdata()
    }
    func setdata(){
        
       for i in 0..<favsarray.count {
        let favitem=favsarray[i]
        let latitude = Double(favitem.latitude)
        let longitude = Double(favitem.longitude)
           
        let artwork = ArtWork(title: favitem.city, locationName: "", discipline: "", coordinates: CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!))
           self.mapView.addAnnotation(artwork)
       }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favsarray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 42
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath) as! FavouritesCell
        
         let favitem = favsarray[indexPath.row]
         cell.lbcity.text = favitem.city
          return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favitem = favsarray[indexPath.row]
        
        let alert=UIAlertController(title: "Alert", message: "Select action for \(favitem.city)", preferredStyle: .alert)
                   
       let action=UIAlertAction(title: "Delete ", style: .default, handler:{ action in
           DispatchQueue.main.async(execute: {
            self.stfavs=self.stfavs.replacingOccurrences(of: favitem.description+"~", with: "")
            self.um.savefavourites(data: self.stfavs)
            self.loadFavData()
           })
           
       })
       let action1=UIAlertAction(title: "Get Weather", style: .default, handler:{ action in
           DispatchQueue.main.async(execute: {
            let vc=self.tabBarController?.viewControllers?[0] as! ViewController
             vc.latitude=favitem.latitude
             vc.longitude=favitem.longitude
             vc.stcity=favitem.city
            
            
            self.tabBarController?.selectedIndex=0
               
           })
           
       })
        let action2=UIAlertAction(title: "Cancel", style: .default, handler:{ action in
            DispatchQueue.main.async(execute: {
                
               
                
            })
            
        })
       
       
       alert.addAction(action)
       alert.addAction(action1)
       alert.addAction(action2)
       
       self.present(alert, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
struct FavItem {
    var description: String
    var city: String
    var latitude: String
    var longitude: String
}
class ArtWork: NSObject, MKAnnotation {

    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinates: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinates
        
    }
    var subtitle: String? {
        return self.locationName
    }
}
