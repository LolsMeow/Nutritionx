//
//  FavoriteViewController.swift
//  iOS Dev
//
//  Created by Jiaming Zheng on 12/8/21.
//
/*
 https://stackoverflow.com/questions/11488057/saving-data-from-tableview-cells-in-core-data
 https://www.youtube.com/watch?v=O7u9nYWjvKk&t=2748s
 */
import Foundation
import UIKit

class FavoriteViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var cells:[Nutrition_Item]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchItems()
    }
    
    func fetchItems() {
        do{
            self.cells = try context.fetch(Nutrition_Item.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch{
            
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cells?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.cells![indexPath.row]
        print(item)
        let cell = tableView.dequeueReusableCell(withIdentifier: "favorite items", for: indexPath) as! NutritionCell
        cell.name?.text = item.name
        cell.calories?.text = item.calories
        cell.fat?.text = item.fat
        cell.serving?.text = item.serving
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { action, view, completionHandler in
            
            let remove_item = self.cells![indexPath.row]
            
            self.context.delete(remove_item)
            
            do {
                try self.context.save()
            }
            catch {
                
            }
            self.fetchItems()
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
}


