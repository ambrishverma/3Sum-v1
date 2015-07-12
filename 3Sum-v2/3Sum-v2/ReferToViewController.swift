//
//  ReferToViewController.swift
//  3Sum-v2
//
//  Created by Ambrish Verma on 7/8/15.
//  Copyright (c) 2015 com.skylord.com. All rights reserved.
//

import UIKit

extension String {
    var isEmail: Bool {
            let regex: NSRegularExpression?
            do {
                regex = try NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .CaseInsensitive)
            } catch _ {
                regex = nil
            }
        return regex?.firstMatchInString(self, options: [], range: NSMakeRange(0, self.characters.count)) != nil
    }
    
    var isPhone: Bool  {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let PHONE_NO_DASH_REFEX = "^\\d{3}\\d{3}\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let phoneTest_noDash = NSPredicate(format: "SELF MATCHES %@", PHONE_NO_DASH_REFEX)
        if (phoneTest.evaluateWithObject(self) || phoneTest_noDash.evaluateWithObject(self)){
            return true
        }
        return false
    }

}

class ReferToViewController: UIViewController {

    @IBOutlet weak var sendToPhoneField: UITextField!
    
    @IBOutlet weak var sendToEmailField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func nextAction(sender: AnyObject) {
        
        // user must provide a valid phone or a valid email address
        if ((sendToPhoneField.text!.utf16.count > 0 && (sendToPhoneField.text!.utf16.count < 10  || !sendToPhoneField.text!.isPhone)) ||
            (sendToEmailField.text!.utf16.count > 0 && (sendToEmailField.text!.utf16.count < 5 || !sendToEmailField.text!.isEmail))
           )
        {
            var alert = UIAlertView(title: "Invalid", message: "Provide proper phone number or email address for your contact", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        } else {
            self.performSegueWithIdentifier("referredBizInfo", sender: self)
        }
        
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let referredBizVc: ReferredBizViewController = segue.destinationViewController as! ReferredBizViewController
        
        referredBizVc.sendToEmail = sendToEmailField.text!
        referredBizVc.sendToPhoneNumber = sendToPhoneField.text!
        
    }
    

}
