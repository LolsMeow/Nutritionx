//
//  myAnnotation.swift
//  iOS Dev
//
//  Created by Jiaming Zheng on 12/1/21.
//

import Foundation
import MapKit

class myAnnotation: NSObject, MKAnnotation{
    
    let title: String?
    let location: String
    let coordinate: CLLocationCoordinate2D
    let menu: [Menu]?
    
    init(title: String, location: String, coordinate: CLLocationCoordinate2D, menu: [Menu]){
        self.title = title
        self.location = location
        self.coordinate = coordinate
        self.menu = menu
        
        super.init()
    }
    
    var subtitle: String?
    {
        return location
    }
    
    var markerTintColor: UIColor
    {
        return .red
    }
}
