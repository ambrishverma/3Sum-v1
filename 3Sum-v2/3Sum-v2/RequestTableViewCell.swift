//
//  RequestTableViewCell.swift
//  3Sum
//
//  Created by Ambrish Verma on 8/4/15.
//  Copyright (c) 2015 com.skylord.com. All rights reserved.
//

import UIKit

class RequestTableViewCell: UITableViewCell {

    
    @IBOutlet weak var senderReceiverImageView: UIImageView!
    
    @IBOutlet weak var senderReceiverNameLabel: UILabel!
    
    @IBOutlet weak var requestMessageTextField: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func clearCell()
    {
        self.senderReceiverNameLabel.text = ""
        self.requestMessageTextField.text = ""
    }

}
