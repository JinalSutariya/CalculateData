//
//  HistoryPageVC.swift
//  Assignment2
//
//  Created by CubezyTech on 04/03/24.
//

import UIKit

class HistoryPageVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - OUTLET
    
    @IBOutlet weak var tableView: UITableView!
    // MARK: - PROPERTY
    var itemsArray: [[String: String]] = []
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Reload data every time the view is about to appear
        itemsArray = CoreDataHandler.shared.fetchDataFromCoreData()
        tableView.reloadData()
    }
    @IBAction func doneBtn(_ sender: Any) {
        dismiss(animated: true)
    }
    //MARK: - TABLEVIEW DELEGATE
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HistoryTableViewCell
        let item = itemsArray[indexPath.row]
        if let itemName = item["itemName"], let itemQuantity = item["itemQuantity"] {
            cell.itemlbl.text = "\(itemQuantity) X \(itemName)"
        }
        cell.dateAndtimeLbl.text = item["timestamp"]
        return cell
    }
    
}
