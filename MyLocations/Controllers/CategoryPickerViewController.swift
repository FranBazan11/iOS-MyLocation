//
//  CategoryPickerViewController.swift
//  MyLocations
//
//  Created by Lagash Systems on 20/03/2020.
//  Copyright © 2020 Lagash Systems. All rights reserved.
//

import UIKit

class CategoryPickerViewController: UITableViewController {
    var selectedCatergoryName = ""
    let categories = [
     "No Category",
     "Apple Store",
     "Bar",
     "Bookstore",
     "Club",
     "Grocery Store",
     "History Building",
     "House",
     "Icecream Vendor",
     "Landmark",
     "Park"]
     var selectedIndexPath = IndexPath()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        for i in 0..<categories.count {
            if categories[i] == selectedCatergoryName{
                selectedIndexPath = IndexPath(row: i, section: 0)
                break
            }
        }
       
    }

   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickedCategory" {
            let cell = sender as! UITableViewCell
            if let indexPath = tableView.indexPath(for: cell){
                selectedCatergoryName = categories[indexPath.row]
                }
            }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       

        // Configure the cell.
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let categoryName = categories[indexPath.row]
        cell.textLabel?.text = categoryName
        
        if categoryName == selectedCatergoryName {
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
        let selection = UIView(frame: CGRect.zero)
        selection.backgroundColor  = UIColor(white: 1.0, alpha: 0.3)
        cell.selectedBackgroundView = selection

        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row != selectedIndexPath.row {
            
            if let newCell = tableView.cellForRow(at: indexPath){
                newCell.accessoryType = .checkmark
            }
            if let oldCell = tableView.cellForRow(at: selectedIndexPath){
                oldCell.accessoryType = .none
                
            }
            selectedIndexPath = indexPath
        }
        }
    

}
