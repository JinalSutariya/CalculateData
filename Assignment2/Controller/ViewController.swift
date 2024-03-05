//
//  ViewController.swift
//  Assignment2
//
//  Created by CubezyTech on 01/03/24.
//

import UIKit
import CoreData

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - OUTLET
    
    @IBOutlet weak var checkMark: UIImageView!
    @IBOutlet weak var oneBtn: UIButton!
    @IBOutlet weak var twoBtn: UIButton!
    @IBOutlet weak var threebtn: UIButton!
    @IBOutlet weak var fourBtn: UIButton!
    @IBOutlet weak var fivebtn: UIButton!
    @IBOutlet weak var sixBtn: UIButton!
    @IBOutlet weak var sevenBtn: UIButton!
    @IBOutlet weak var eightBtn: UIButton!
    @IBOutlet weak var nineBtn: UIButton!
    @IBOutlet weak var cBtn: UIButton!
    @IBOutlet weak var zeroBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var qunTxtField: UITextField!
    
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var managerbtn: UIButton!
    @IBOutlet weak var buyBtn: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    
    // MARK: - PROPERTY
    
    var items = [
        ["Computer", "4", "$500"],
        ["Monitor", "4", "$200"]
    ]
    var selectedItemPrice: Double? = nil
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkMark.isHidden = true
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.reloadAllComponents()

        pickerView.selectRow(0, inComponent: 0, animated: false)
        updateItemLabel(row: 0)
        
        
        
        qunTxtField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        managerbtn.addTarget(self, action: #selector(managerButtonTapped), for: .touchUpInside)
        
    }
   
    @objc func textFieldDidChange(_ textField: UITextField) {
        updateTotalPrice()
    }
    @objc func managerButtonTapped() {
        let alertController = UIAlertController(title: "Enter Code", message: "", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Code"
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { _ in
            
            if let inputCode = alertController.textFields?[0].text, !inputCode.isEmpty {
                print(inputCode)
                
                let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBar") as! UITabBarController
                tabBarController.modalPresentationStyle = .fullScreen
                
                self.present(tabBarController, animated: true, completion: nil)
                
            } else {
                let emptyCodeAlert = UIAlertController(title: "Error", message: "Please enter a valid code.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                emptyCodeAlert.addAction(okAction)
                self.present(emptyCodeAlert, animated: true, completion: nil)
            }
        }
        
        alertController.addAction(submitAction)
        
        present(alertController, animated: true, completion: nil)
    }
    // MARK: - BUTTON CLICK
    
    @IBAction func numberButtonPressed(_ sender: UIButton) {
        guard let currentText = qunTxtField.text, let buttonText = sender.titleLabel?.text else {
            return
        }
        
        qunTxtField.text = currentText + buttonText
        
        updateTotalPrice()
    }
    @IBAction func backButtonPressed(_ sender: UIButton) {
        checkMark.isHidden = true
        
        guard var currentText = qunTxtField.text else {
            return
        }
        
        currentText = String(currentText.dropLast())
        
        qunTxtField.text = currentText
        
        updateTotalPrice()
    }
    @IBAction func buyButtonPressed(_ sender: UIButton) {
        
        checkMark.isHidden = false
        // saveToCoreData()
        CoreDataHandler.shared.saveToCoreData(itemName: itemName.text, itemQun: qunTxtField.text, itemPrice: totalPrice.text)
    }
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        checkMark.isHidden = true
        totalPrice.textColor = UIColor.black
        
        qunTxtField.text = ""
        
        totalPrice.text = "$0"
        
        selectedItemPrice = nil
        
        pickerView.selectRow(0, inComponent: 0, animated: true)
        updateItemLabel(row: 0)
        
        // Reset the items array to the initial values
        items = [
            ["Computer", "4", "$500"],
            ["Monitor", "4", "$200"]
        ]
    }
    
    // MARK: - ALL CUSTOM FUNCTION
    
    func updateItemLabel(row: Int) {
        itemName.text = "\(items[row][0])"
    }
  
    func updateTotalPrice() {
        
        if let quantityText = qunTxtField.text, let quantity = Double(quantityText), quantity > 4 {
            totalPrice.textColor = UIColor.red
            buyBtn.isEnabled = false
            buyBtn.setTitleColor(UIColor.gray, for: .normal)
        } else {
            totalPrice.textColor = UIColor.black
            buyBtn.isEnabled = true
            buyBtn.setTitleColor(UIColor.systemBlue, for: .normal)
        }
        if let quantityText = qunTxtField.text, let quantity = Double(quantityText), quantity > 0 {
            let selectedRow = pickerView.selectedRow(inComponent: 0)
            var itemName = items[selectedRow][0]
            var itemQuantity = items[selectedRow][1]
            var itemPriceString = items[selectedRow][2].replacingOccurrences(of: "$", with: "")
            
            itemQuantity = "\(quantity)"
            if let newItemPrice = selectedItemPrice {
                itemPriceString = "\(newItemPrice)"
            }
            
            items[selectedRow] = [itemName, itemQuantity, "$\(itemPriceString)"]
            
            let totalPriceValue = quantity * Double(itemPriceString)!
            totalPrice.text = "$\(totalPriceValue)"
        } else {
            totalPrice.text = "$0"
        }
    }
    // MARK: - UIPickerViewDelegate and UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.text = items[row][component]
        label.textAlignment = .center
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateItemLabel(row: row)
        
        if let price = Double(items[row][2].replacingOccurrences(of: "$", with: "")) {
            selectedItemPrice = price
        }
        
        pickerView.selectRow(row, inComponent: 0, animated: true)
        pickerView.selectRow(row, inComponent: 1, animated: true)
        pickerView.selectRow(row, inComponent: 2, animated: true)
        
        // Clear the total price value when pickerView is scrolled
        qunTxtField.text = ""
        
        updateTotalPrice()
    }
    
}
