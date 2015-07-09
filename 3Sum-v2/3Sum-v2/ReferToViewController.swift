//
//  ReferToViewController.swift
//  3Sum-v2
//
//  Created by Ambrish Verma on 7/8/15.
//  Copyright (c) 2015 com.skylord.com. All rights reserved.
//

import UIKit

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
        if (count(sendToPhoneField.text.utf16) < 10 || count(sendToEmailField.text.utf16) < 4) {
            var alert = UIAlertView(title: "Invalid", message: "Provide proper phone number or emails for your contact", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        } else {
            self.performSegueWithIdentifier("referredBizInfo", sender: self)
        }
        
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var referredBizVc: ReferredBizViewController = segue.destinationViewController as! ReferredBizViewController
        
        referredBizVc.sendToEmail = sendToEmailField.text
        referredBizVc.sendToPhoneNumber = sendToPhoneField.text
        
    }
    

}
