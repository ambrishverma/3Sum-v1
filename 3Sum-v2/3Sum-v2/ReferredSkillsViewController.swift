//
//  ReferredSkillsViewController.swift
//  3Sum-v2
//
//  Created by Ambrish Verma on 7/8/15.
//  Copyright (c) 2015 com.skylord.com. All rights reserved.
//

import UIKit
import Parse

class referralObject {
    var referrerPhone: String = ""
    var referreePhone: String = ""
    var referreeEmail: String = ""
    var referredBizPhone: String = ""
    var referredBizEmail: String = ""
    var referredBizName: String = ""
    var referredBizSkills: String = ""
}

class ReferredSkillsViewController: UIViewController {
    
    @IBOutlet weak var skillField: UITextField!
    
    var refData: referralObject = referralObject()
    
    var object: PFObject!
    
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.actInd.center = self.view.center
        self.actInd.hidesWhenStopped = true
        self.actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(self.actInd)
        
        if (self.object != nil) {
            // populate existing business
            /*
            self.titleField?.text = self.object["title"] as! String
            self.textView?.text = self.object["text"] as! String
            self.tagField?.text = self.object["taggedList"] as! String
            */
        } else {
            self.object = PFObject(className: "Referrals")
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func sendAction(sender: AnyObject) {
   //     self.refData.referrerPhone = PFUser.currentUser()?.username!
        println(" referred biz phone: \(self.refData.referredBizPhone)")
        println("sending referral")
        
        
        if (count(skillField.text.utf16) < 2) {
            var alert = UIAlertView(title: "Invalid", message: "Sending generic reference, else please select/type appropriate skills", delegate: self, cancelButtonTitle: "OK")
            skillField.text = "General"
            alert.show()
        } else {	
            self.actInd.startAnimating()
            
            self.object["ReferrerPhone"] = PFUser.currentUser()?.username!
            self.object["ReferreePhone"] = self.refData.referreePhone
            self.object["RefereeEmail"] = self.refData.referreeEmail
            self.object["ReferredBizPhone"] = self.refData.referredBizPhone
            self.object["ReferredBizEmail"] = self.refData.referredBizEmail
            self.object["ReferredBizName"] = self.refData.referredBizName
            self.object["ReferredBizSkills"] = skillField.text
            
        
            self.object.saveInBackgroundWithBlock({ (success, error) -> Void in
                if (success) {
                    println("data saved")
                } else {
                    println(error)
                }
                
            })
            self.navigationController?.popToRootViewControllerAnimated(true)
            
        }
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
