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
    
    func SendPushForReferredBiz() {
        // Create our Installation query
        let pushQuery = PFInstallation.query()
        pushQuery!.whereKey("user", equalTo: self.refData.referredBizPhone)
        pushQuery!.whereKey("channels", equalTo: "referrals")
        
        // Send push notification to query
        let push = PFPush()
        push.setQuery(pushQuery) // Set our Installation query
        push.setMessage("\(self.refData.referrerPhone) just referred you for \(self.refData.referredBizSkills) to \(self.refData.referreePhone)")
        push.sendPushInBackgroundWithBlock { (result, error) -> Void in
            println("sent push to \(self.refData.referredBizPhone): \(error)")
        }
    }


    func SendPushForReferral() {
        // Create our Installation query
        let pushQuery = PFInstallation.query()
        pushQuery!.whereKey("user", equalTo: self.refData.referreePhone)
        pushQuery!.whereKey("channels", equalTo: "referrals")
        
        // Send push notification to query
        let push = PFPush()
        push.setQuery(pushQuery) // Set our Installation query
        if (self.refData.referredBizName != "") {
            push.setMessage("\(self.refData.referrerPhone) sent you reference to \(self.refData.referredBizName) for \(self.refData.referredBizSkills)")
        } else {
            push.setMessage("\(self.refData.referrerPhone) sent you reference to \(self.refData.referredBizPhone) for \(self.refData.referredBizSkills)")
        }
        push.sendPushInBackgroundWithBlock { (result, error) -> Void in
            println("sent push to \(self.refData.referreePhone): \(error)")
        }
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
            
            self.refData.referrerPhone = PFUser.currentUser()!.username!
            self.refData.referredBizSkills = skillField.text
            self.object["ReferrerPhone"] = self.refData.referrerPhone
            self.object["ReferreePhone"] = self.refData.referreePhone
            self.object["RefereeEmail"] = self.refData.referreeEmail
            self.object["ReferredBizPhone"] = self.refData.referredBizPhone
            self.object["ReferredBizEmail"] = self.refData.referredBizEmail
            self.object["ReferredBizName"] = self.refData.referredBizName
            self.object["ReferredBizSkills"] = self.refData.referredBizSkills
            
        
            self.object.saveInBackgroundWithBlock({ (success, error) -> Void in
                if (success) {
                    println("data saved")
                    self.SendPushForReferral()
                    self.SendPushForReferredBiz()
                } else {
                    println(error)
                }
                
            })

            self.navigationController?.popToRootViewControllerAnimated(true)
            
        }
        
    }
    
    @IBAction func handymanAction(sender: AnyObject) {
        skillField.text = "Handyman"
    }

    @IBAction func cleaningAction(sender: AnyObject) {
        skillField.text = "Cleaning"
    }
    @IBAction func plumbingAction(sender: AnyObject) {
        skillField.text = "Plumbing"
    }
    @IBAction func electricalsAction(sender: AnyObject) {
        skillField.text = "Electricals"
    }
    @IBAction func movingAction(sender: AnyObject) {
        skillField.text = "Moving"
    }
    @IBAction func paintingAction(sender: AnyObject) {
        skillField.text = "Painting"
    }
    @IBAction func realEstateAction(sender: AnyObject) {
        skillField.text = "Real-Estate"
    }
    @IBAction func accountantAction(sender: AnyObject) {
        skillField.text = "Accountant"
    }

    @IBAction func dentistAction(sender: AnyObject) {
        skillField.text = "Dentist"
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
