//
//  SaveCoreData.swift
//  Assignment2
//
//  Created by CubezyTech on 04/03/24.
//
import CoreData
import Foundation
import UIKit


class CoreDataHandler {
    static let shared = CoreDataHandler()
    
    private init() {}
    
    func fetchDataFromCoreData() -> [[String: String]] {
        var itemsArray = [[String: String]]()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return itemsArray
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
            
            for data in results as! [NSManagedObject] {
                let itemName = data.value(forKey: "itemName") as? String ?? ""
                let itemQuantity = data.value(forKey: "itemQun") as? String ?? ""
                let itemPrice = data.value(forKey: "itemPrice") as? String ?? ""
                let timestamp = data.value(forKey: "timestamp") as? Date ?? Date()
                
                // Format the timestamp to a string in "2:14 PM" format
                let formattedTimestamp = dateFormatter.string(from: timestamp)
                
                let newItem: [String: String] = ["itemName": itemName, "itemQuantity": itemQuantity, "itemPrice": itemPrice, "timestamp": formattedTimestamp]
                itemsArray.append(newItem)
                print(newItem)
            }
        } catch let error as NSError {
            print("Could not fetch data from CoreData. \(error), \(error.userInfo)")
        }
        
        return itemsArray
    }
    func deleteItem(itemName: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
        fetchRequest.predicate = NSPredicate(format: "itemName == %@", itemName)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            if let objectToDelete = result.first as? NSManagedObject {
                managedContext.delete(objectToDelete)
                try managedContext.save()
                print("Item deleted successfully")
            }
        } catch let error as NSError {
            print("Could not delete item. \(error), \(error.userInfo)")
        }
    }
    func saveToCoreData(itemName: String?, itemQun: String?, itemPrice: String?) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Entity", in: managedContext)!
        
        let item = NSManagedObject(entity: entity, insertInto: managedContext)
        item.setValue(itemName, forKeyPath: "itemName")
        item.setValue(itemQun, forKeyPath: "itemQun")
        item.setValue(itemPrice, forKeyPath: "itemPrice")
        
        do {
            try managedContext.save()
            print("Data saved to CoreData")
        } catch let error as NSError {
            print("Could not save to CoreData. \(error), \(error.userInfo)")
        }
    }
    func fetchItem(itemName: String, context: NSManagedObjectContext) -> Entity? {
        let fetchRequest: NSFetchRequest<Entity> = Entity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "itemName == %@", itemName)
        
        do {
            let items = try context.fetch(fetchRequest)
            return items.first
        } catch {
            print("Error fetching item: \(error)")
            return nil
        }
    }
    func updateItem(itemName: String, newItemName: String?, newItemQun: String?, newItemPrice: String?) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
        fetchRequest.predicate = NSPredicate(format: "itemName == %@", itemName)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            if let objectToUpdate = result.first as? NSManagedObject {
                // Update the values if new values are provided
                if let newName = newItemName {
                    objectToUpdate.setValue(newName, forKey: "itemName")
                }
                if let newQun = newItemQun {
                    objectToUpdate.setValue(newQun, forKey: "itemQun")
                }
                if let newPrice = newItemPrice {
                    objectToUpdate.setValue(newPrice, forKey: "itemPrice")
                }
                
                try managedContext.save()
                print("Item updated successfully")
            }
        } catch let error as NSError {
            print("Could not update item. \(error), \(error.userInfo)")
        }
    }
}
