//
//  EditDataVC.swift
//  Assignment2
//
//  Created by CubezyTech on 04/03/24.
//

import UIKit
import CoreData
protocol EditDataDelegate: AnyObject {
    func didSaveData()
}

class EditDataVC: UIViewController {
    
    // MARK: - OUTLET
    
    @IBOutlet weak var qunTxtField: UITextField!
    @IBOutlet weak var valueTxtField: UITextField!
    @IBOutlet weak var titleTxtField: UITextField!
    
    // MARK: - PROPERTY
    weak var delegate: EditDataDelegate?
    
    var itemName: String?
    var itemQuantity: String?
    var itemPrice: String?
    var managedObjectContext: NSManagedObjectContext?
    var selectedItem: [String: String]?
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedItem = selectedItem {
            // Update UI with selectedItem details (e.g., text fields, labels, etc.)
            titleTxtField.text = selectedItem["itemName"]
            qunTxtField.text = selectedItem["itemQuantity"]
            valueTxtField.text = selectedItem["itemPrice"]
        }
    }
    
    // MARK: - BUTTON CLICK
    
    @IBAction func saveBtn(_ sender: Any) {
        
        if let itemName = selectedItem?["itemName"] {
            CoreDataHandler.shared.updateItem(itemName: itemName, newItemName: titleTxtField.text, newItemQun: qunTxtField.text, newItemPrice: valueTxtField.text)
        } else {
            // If selectedItem is nil, it's a new item, so save it to Core Data
            saveDataToCoreData()
        }
        
        // Notify the delegate
        delegate?.didSaveData()
        
        // Dismiss the view controller
        dismiss(animated: true)
    }
    
    func saveDataToCoreData() {
        guard let context = managedObjectContext else {
            return
        }
        
        // Create a new entity
        let newItem = Entity(context: context)
        
        // Set values from text fields
        newItem.itemName = titleTxtField.text
        
        // Check if the value starts with "$" and remove it before saving
        if let value = valueTxtField.text, value.hasPrefix("$") {
            newItem.itemPrice = String(value.dropFirst())
        } else {
            newItem.itemPrice = valueTxtField.text
        }
        
        newItem.itemQun = qunTxtField.text
        
        // Save the context
        do {
            try context.save()
            print("Data saved successfully")
        } catch {
            print("Error saving data: \(error)")
        }
    }
    
    
    @IBAction func cancelBtn(_ sender: Any) {
        dismiss(animated: true)
    }
}
