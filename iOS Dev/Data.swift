//
//  Data.swift
//  iOS Dev
//
//  Created by Jiaming Zheng on 11/29/21.
//

import Foundation

struct Data: Codable{
    
    var restaurant_name:String?
    var restaurant_phone:String?
    var restaurant_website:String?
    var hours:String?
    var price_range:String?
    var restaurant_id:Int?
    var address:Address?
    var geo:Coordinates?
    var menus:[Menu]?
    
}
