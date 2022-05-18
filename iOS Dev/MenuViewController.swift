//
//  MenuViewController.swift
//  iOS Dev
//
//  Created by Jiaming Zheng on 12/2/21.
//
/*
 https://developer.apple.com/documentation/uikit/views_and_controls/table_views
 https://developer.apple.com/documentation/uikit/views_and_controls/table_views/filling_a_table_with_data
 */
import Foundation
import UIKit
import CoreLocation
import MapKit

class MenuViewController: UITableViewController, MKMapViewDelegate {
    
    var data:myAnnotation?
    var menu_section:[String] = []
    var menu_sects:[[Items]] = [[]]
    var menu_item:[Items] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let data = data else {
            return
        }
        guard let menu = data.menu else {
            return
        }
        //Access Menu
        for i in menu{
            let sections = i.menu_sections
            //Access Section
            for j in sections{
                let s_name = j.section_name
                menu_section.append(s_name)
                
                let items = j.menu_items
                //Access Menu Items
                menu_item = []
                for k in items{
                    menu_item.append(k)
                }
                menu_sects.append(menu_item)
            }
            menu_sects.remove(at: 0)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return menu_sects.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let items = menu_sects[section].count
        return items
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sect = menu_sects[indexPath.section]
        let items = sect[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "menu item", for: indexPath) as! FoodCell
        
        cell.name?.text = items.name + " - $" + String(format: "%.2f", items.price)
        cell.desc?.text = (items.description).uppercased()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       return menu_section[section]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FoodCell
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "nutrition", sender: cell)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nutrition" {
            let vc = segue.destination as! NutritionViewController
            vc.nutrition = (sender as! FoodCell)
        }
    }
}

