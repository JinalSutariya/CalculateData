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
            
            titleTxtField.text = selectedItem["itemName"]
            qunTxtField.text = selectedItem["itemQuantity"]
            valueTxtField.text = selectedItem["itemPrice"]
        }
    }
    
    // MARK: - BUTTON CLICK
    
    @IBAction func saveBtn(_ sender: Any) {
        
        // Check if any of the text fields are empty
        guard let itemName = titleTxtField.text, !itemName.isEmpty,
              let itemQuantity = qunTxtField.text, !itemQuantity.isEmpty,
              let itemPrice = valueTxtField.text, !itemPrice.isEmpty else {
            
            // Display an alert if any of the fields are empty
            let alert = UIAlertController(title: "", message: "Please enter values for all fields", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        }
        
        if let selectedItemName = selectedItem?["itemName"] {
            CoreDataHandler.shared.updateItem(itemName: selectedItemName, newItemName: itemName, newItemQun: itemQuantity, newItemPrice: itemPrice)
        } else {
            saveDataToCoreData()
        }
        
        delegate?.didSaveData()
        
        dismiss(animated: true)
    }
    
    func saveDataToCoreData() {
        guard let context = managedObjectContext else {
            return
        }
        
        // Create a new entity
        let newItem = Entity(context: context)
        
        newItem.itemName = titleTxtField.text
        
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
