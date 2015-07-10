//
//  OfferViewCell.swift
//  3Sum-v2
//
//  Created by Ambrish Verma on 7/9/15.
//  Copyright (c) 2015 com.skylord.com. All rights reserved.
//

import UIKit

class OfferViewCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var skillsLabel: UILabel!
    @IBOutlet weak var referrerPhoneLabel: UILabel!
    @IBOutlet weak var offerDealLabel: UILabel!
    
 //   var referral: Offer!;

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

/*
    func setOffer(_referal: referral) -> Void{
        self.business = _business;
        
        self.thumbImageView.setImageWithURL(NSURL(string: self.business.imageUrl));
        self.nameLabel.text = self.business.name;
        self.distanceLabel.text = NSString(format: "%.2f mi", self.business.distance);
        self.ratingImageView.setImageWithURL(NSURL(string: self.business.ratingImageUrl));
        self.ratingLabel.text = NSString(format: "%ld Reviews", self.business.numReviews);
        self.addressLabel.text = self.business.address;
        self.categoryLabel.text = self.business.categories;
    }
*/
    
    func clearCell()
    {
        self.nameLabel.text = ""
        self.phoneLabel.text = ""
        self.emailLabel.text  = ""
        self.addressLabel.text = ""
        self.skillsLabel.text = ""
        self.referrerPhoneLabel.text = ""
        self.offerDealLabel.text = ""
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
