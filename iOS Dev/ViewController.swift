//
//  ViewController.swift
//  iOS Dev
//
//  Created by Jiaming Zheng on 11/19/21.
//

import UIKit
import Foundation
import CoreLocation
import MapKit
import CoreData

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var button: UIButton!
    var locationManager = CLLocationManager()
    var currentLocation:CLLocation!
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func locateMe(_ sender: UIButton) {
        print("Working")
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

    }
    
    @IBAction func favorite(sender: UIButton){
        performSegue(withIdentifier: "favorite", sender: self)
        print("favorite")
    }
    
    func geoSearch(lat: String, long: String) -> String {
        let api = String("https://documenu.p.rapidapi.com/restaurants/search/geo?")
        let lati = String("lat=" + lat + "&")
        let longi = String("lon=" + long + "&&")
        let disi = String("distance=" + "1" + "&")
        let end = String("fullmenu=true&top_cuisines=false")
        let result = String(api + lati + longi + disi + end)
        return result
    }
    
    //https://stackoverflow.com/questions/40331986/adding-pins-to-map-using-mapkit-swift-3-0
    func addCustomPin(name: String, address: String, coords: CLLocationCoordinate2D, menu: [Menu]) {
        let pin = myAnnotation(title: name, location: address, coordinate: coords, menu: menu)
        DispatchQueue.main.async {
            self.map.addAnnotation(pin)
        }
//        map.addAnnotation(pin)
    }
    
    //https://developer.apple.com/documentation/mapkit/mapkit_annotations/annotating_a_map_with_custom_data
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = MKMarkerAnnotationView()
        guard !(annotation is MKUserLocation) else {return nil}
        let identifier = "custom"
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            annotationView = dequeuedView
        }else{
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.canShowCallout = true
            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return annotationView
    }
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        guard !(annotation is MKUserLocation) else {
//            return nil
//        }
//
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
//
//        if annotationView == nil{
//            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Custom")
//            annotationView?.image = UIImage(named:"icon")
//            annotationView?.canShowCallout = true
//        }
//        else{
//            annotationView?.annotation = annotation
//        }
//        return annotationView
//    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let data = view.annotation as! myAnnotation
        
        performSegue(withIdentifier: "menu", sender: data)
    }
    // https://stackoverflow.com/questions/36148107/passing-data-to-segue-from-annotation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "menu" && sender is myAnnotation{
            let vc = segue.destination as! MenuViewController
            vc.data = (sender as! myAnnotation)
        }
        if segue.identifier == "favorite" {
            let vc = segue.destination as! FavoriteViewController
        }
    }
    
    //https://www.advancedswift.com/user-location-in-swift/
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("working")
    //Location Services
        let userLocation:CLLocation = locations[0] as CLLocation
        let coordinations = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.003,longitudeDelta: 0.003)
        let region = MKCoordinateRegion(center: coordinations, span: span)
        map.setRegion(region, animated: true)
    //Documenu API Call
        let lat: String = String(format: "%f", userLocation.coordinate.latitude)
        let long: String = String(format: "%f", userLocation.coordinate.longitude)
        let result = geoSearch(lat: lat, long: long)
        
        //https://www.youtube.com/watch?v=3nwcNLM3KOU&t=918s
        // URL
        let url = URL(string: result)
        guard url != nil else {
              return
          }
        
        //URL Request
        var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        
        // Specify the Headers
        let headers = [
            "x-api-key": "",
            "x-rapidapi-host": "documenu.p.rapidapi.com",
            "x-rapidapi-key": ""
        ]
        request.allHTTPHeaderFields = headers
        
        // Set the request type
        request.httpMethod = "GET"
        
        // Get the URLSession
        let session = URLSession.shared
        
        // Create the Data Task
        let dataTask = session.dataTask(with: request) { data, response, error in
            
            // Check for error
            if error == nil && data != nil{
                
                //https://www.youtube.com/watch?v=_TrPJQWD8qs
                // Parse the data
                do {
                    let decoder = JSONDecoder()
                    let restaurant = try decoder.decode(Restaurant.self, from: data!)

                    guard let info = restaurant.data else{
                        return
                    }
                    for i in info{
                        guard let name = i.restaurant_name else{
                            return
                        }
                        guard let addr = i.address else{
                            return
                        }
                        guard let address = addr.formatted else{
                            return
                        }
                        guard let geo = i.geo else{
                            return
                        }
                        guard let lat = geo.lat else{
                            return
                        }
                        guard let long = geo.lon else{
                            return
                        }
                        let coords = CLLocationCoordinate2D(latitude: lat, longitude: long)
                        guard let menu = i.menus else{
                            return
                        }
                        self.addCustomPin(name: name, address: address, coords: coords, menu: menu)
                    }
                }
                catch{
                    print("Error on decode: \(error)")
                }
            }

        }
        // Activate Data Task
        dataTask.resume()

    }
}


