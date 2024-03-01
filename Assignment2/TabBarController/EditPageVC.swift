//
//  EditPageVC.swift
//  Assignment2
//
//  Created by CubezyTech on 04/03/24.
//

import UIKit
import CoreData

class EditPageVC: UIViewController, UITableViewDelegate, UITableViewDataSource, EditDataDelegate {
    
    
    // MARK: - OUTLET
    
    @IBOutlet weak var tableView: UITableView!
    // MARK: - PROPERTY
    var itemsArray: [[String: String]] = []
    var selectedIndexPath: IndexPath?
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemsArray = CoreDataHandler.shared.fetchDataFromCoreData()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    // MARK: - BUTTON CLICK
    
    @IBAction func addBtn(_ sender: Any) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let main = storyboard.instantiateViewController(withIdentifier: "editData") as! EditDataVC
        main.managedObjectContext = managedObjectContext
        main.delegate = self  // Set YourTableViewController as the delegate
        
        main.modalPresentationStyle = .fullScreen
        self.present(main, animated: true, completion: nil)
    }
    
    @IBAction func doneBtn(_ sender: Any) {
        dismiss(animated: true)
        
    }
    func didSaveData() {
        // Reload data in the table view when data is edited in EditDataVC
        itemsArray = CoreDataHandler.shared.fetchDataFromCoreData()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    //MARK: - TABLEVIEW DELEGATE
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EditTableViewCell
        let item = itemsArray[indexPath.row]
        
        if let itemName = item["itemName"], let itemQuantity = item["itemQuantity"] {
            cell.itemLbl.text = "\(itemName) (\(itemQuantity))"
        }
        
        if let itemPrice = item["itemPrice"], let numericValue = Double(itemPrice),
           let itemQuantity = item["itemQuantity"], let numericQuantity = Double(itemQuantity) {
            
            // Calculate total value by multiplying quantity and price
            let totalValue = numericValue * numericQuantity
            let formattedTotal = String(format: "$ %.2f", totalValue)
            cell.priceLbl.text = formattedTotal
        } else {
            cell.priceLbl.text = item["itemPrice"]
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editDataVC = storyboard.instantiateViewController(withIdentifier: "editData") as! EditDataVC
        
        // Pass the selected item details to EditDataVC
        editDataVC.selectedItem = itemsArray[indexPath.row]
        
        // Set EditPageVC as the delegate to receive updates
        editDataVC.delegate = self
        
        editDataVC.modalPresentationStyle = .fullScreen
        // Present the EditDataVC
        present(editDataVC, animated: true, completion: nil)
        
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove the item from CoreData
            if let itemName = itemsArray[indexPath.row]["itemName"] {
                CoreDataHandler.shared.deleteItem(itemName: itemName)
            }
            
            // Remove the item from the data source array
            itemsArray.remove(at: indexPath.row)
            
            // Update the table view
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}

