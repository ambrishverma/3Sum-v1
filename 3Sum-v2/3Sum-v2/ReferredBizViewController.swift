//
//  ReferredBizViewController.swift
//  3Sum-v2
//
//  Created by Ambrish Verma on 7/8/15.
//  Copyright (c) 2015 com.skylord.com. All rights reserved.
//

import UIKit

class ReferredBizViewController: UIViewController {

    var sendToPhoneNumber: String = ""
    var sendToEmail: String = ""
    
    @IBOutlet weak var referredBizNameField: UITextField!
    
    @IBOutlet weak var referredPhoneNumberField: UITextField!    
    
    @IBOutlet weak var referredEmailField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func nextAction(sender: AnyObject) {
        if (count(referredBizNameField.text.utf16) < 2 ||
            (count(referredPhoneNumberField.text.utf16) > 0 && (count(referredPhoneNumberField.text.utf16) < 10  || !referredPhoneNumberField.text.isPhone)) ||
            (count(referredEmailField.text.utf16) > 0 && (count(referredEmailField.text.utf16) < 5 || !referredEmailField.text.isEmail))
         )
        {
            var alert = UIAlertView(title: "Invalid", message: "Provide business/person name and a valid phone number/email address you are referring", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        } else {
            self.performSegueWithIdentifier("referredSkills", sender: self)
        }
        
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var referredSkillsVc: ReferredSkillsViewController = segue.destinationViewController as! ReferredSkillsViewController

        referredSkillsVc.refData.referreePhone = sendToPhoneNumber
        referredSkillsVc.refData.referreeEmail = sendToEmail
        
        referredSkillsVc.refData.referredBizPhone = referredPhoneNumberField.text
        referredSkillsVc.refData.referredBizEmail = referredEmailField.text
        referredSkillsVc.refData.referredBizName = referredBizNameField.text
    }


}
