//
//  NutritionViewController.swift
//  iOS Dev
//
//  Created by Jiaming Zheng on 12/5/21.
//

import Foundation
import UIKit
import CoreData

class NutritionViewController: UITableViewController {
    
    
    var nutrition:FoodCell?
    var nutrition_data:[Fields] = []
    var nutrition_ID:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Unwrap Data
        guard let nutrition = nutrition else {return}
        guard let name = nutrition.name else {return}
        guard let food_name = name.text else {return}
        
        // API Call
        let result = nutritionSearch(name: food_name)
        
        // URL
        let url = URL(string: result)
        guard url != nil else {return}
        
        // URL Request
        var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        
        // Specify the headers
        let headers =
        [
            "x-rapidapi-host": "nutritionix-api.p.rapidapi.com",
            "x-rapidapi-key": "3f5c9b698bmsh4a33f82d27cbb8dp1744e9jsn84d55dd9c721"
        ]
        request.allHTTPHeaderFields = headers
        
        // Set the request type
        request.httpMethod = "GET"
        
        // Get the URLSession
        let session = URLSession.shared
        
        // Create the Data Task
        let dataTask = session.dataTask(with: request) { data, request, error in
            
            if error == nil && data != nil {
                
                do {
                    let decoder = JSONDecoder()
                    let nutritions = try decoder.decode(Nutrition.self, from: data!)
                    let hit = nutritions.hits
                    DispatchQueue.main.async {
                        for i in hit{
                            let field = i.fields
                            let id = i._id
                            self.nutrition_ID.append(id)
                            self.nutrition_data.append(field)
                        }
                        self.tableView.reloadData()
                    }
                }
                catch {
                    print("Error on decode: \(error)")
                }
            }
        }
        dataTask.resume()
    }
    
    func nutritionSearch(name: String) -> String {
        let api = "https://nutritionix-api.p.rapidapi.com/v1_1/search/"
        let nameArr = name.components(separatedBy: " ")
        var searchName = ""
        
        for i in 0...nameArr.count-1 {
            if i == nameArr.count-1{
                searchName = searchName + String(nameArr[i])
            }
            else{
                searchName = searchName + String(nameArr[i] + "%20")
            }
        }
        let fields = "?fields=item_name%2Cbrand_name%2Cnf_calories%2Cnf_total_fat"
        let result = String(api + searchName + fields)
        return result
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nutrition_data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let items = self.nutrition_data[indexPath.row]
        let id = self.nutrition_ID[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "nutrition items", for: indexPath) as! NutritionCell
        cell.id = id
        cell.name?.text = items.item_name + " - " + items.brand_name
        cell.calories?.text = "Calories: " + String(format:"%.1f", items.nf_calories)
        cell.fat?.text = "Fat: " + String(format:"%.1f", items.nf_total_fat)
        cell.serving?.text = String(items.nf_serving_size_qty) + " " + items.nf_serving_size_unit
        return cell
    }
}
