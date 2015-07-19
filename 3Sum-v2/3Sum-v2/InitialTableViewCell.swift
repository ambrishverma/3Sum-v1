//
//  InitialTableViewCell.swift
//  3Sum-v2
//
//  Created by Ambrish Verma on 7/17/15.
//  Copyright (c) 2015 com.skylord.com. All rights reserved.
//

import UIKit

class InitialTableViewCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func clearCell()
    {
        nameLabel.text = ""
    }
    
    func createLogoCell() {
        nameLabel.text = "Logo"
    }
    
    func createAskReferralCell() {
        nameLabel.text = "Ask Someone"
    }
    
    func createReferSomeoneCell() {
        nameLabel.text = "Refer Someone"
        
    }
    
    func createViewReferralsCell() {
        nameLabel.text = "View Referrals"
        
    }
    
    func createManageServicesCell() {
        nameLabel.text = "Manage Services"
        
    }


    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
