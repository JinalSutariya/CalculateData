//
//  HistoryTableViewCell.swift
//  Assignment2
//
//  Created by CubezyTech on 04/03/24.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    // MARK: - OUTLET
    
    @IBOutlet weak var dateAndtimeLbl: UILabel!
    @IBOutlet weak var itemlbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
