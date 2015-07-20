//
//  AskSomeoneViewController.swift
//  3Sum-v2
//
//  Created by Ambrish Verma on 7/20/15.
//  Copyright (c) 2015 com.skylord.com. All rights reserved.
//

import UIKit
import Parse

class AskSomeoneViewController: UIViewController {
    
    
    @IBOutlet weak var phoneTextField: UITextField!

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var messageTextField: UITextField!

    
    
    
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
            self.object = PFObject(className: "RefRequests")
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func showAlert(title: String, message: String) {
        return UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: NSLocalizedString("alertOK", comment: "OK")).show()
    }
    
    func sendMsgToReferrer(phoneNumber: String, messageString: String)  {
        self.editing = false
        let params = ["phoneNumber" : phoneNumber, "message" : messageString ]
        PFCloud.callFunctionInBackground("sendMessage", withParameters: params) {
            (response: AnyObject?, error: NSError?) -> Void in
            self.editing = true
            if let error = error {
                var description = error.description
                if count(description) == 0 {
                    description = NSLocalizedString("warningGeneral", comment: "Something went wrong.  Please try again.") // "There was a problem with the service.\nTry again later."
                } else if let message = error.userInfo?["error"] as? String {
                    description = message
                }
                //               self.showAlert("Login Error", message: description)
            }
        }
    }
    
    
    func SendPushToReferrer(messageTxt: String) {
        // Create our Installation query
        let pushQuery = PFInstallation.query()
        pushQuery!.whereKey("user", equalTo: phoneTextField.text)
        pushQuery!.whereKey("channels", equalTo: "referrals")
        
        // Send push notification to query
        let push = PFPush()
        push.setQuery(pushQuery) // Set our Installation query
        push.setMessage(messageTxt)
        push.sendPushInBackgroundWithBlock { (result, error) -> Void in
            println("sent push to \(self.phoneTextField.text): \(error)")
        }
        sendMsgToReferrer(self.phoneTextField.text, messageString: messageTxt)
    }
    

    @IBAction func sendRequestAction(sender: AnyObject) {
        println("sending request request")
        
        
        if ((count(phoneTextField.text.utf16) > 0 && (count(phoneTextField.text.utf16) < 10  || !phoneTextField.text.isPhone)) ||
            (count(emailTextField.text.utf16) > 0 && (count(emailTextField.text.utf16) < 5 || !emailTextField.text.isEmail)) ||
            (count(messageTextField.text) < 4)
            )
        {
            var alert = UIAlertView(title: "Invalid", message: "Provide proper phone number or email address and brief message for your request", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        } else {
            self.actInd.startAnimating()
            
            self.object["ReferrerPhone"] = phoneTextField.text
            self.object["RefererEmail"] = emailTextField.text
            self.object["RequesterPhone"] = PFUser.currentUser()?.username!
            self.object["ReferralRequestMessage"] = messageTextField.text
            
            
            self.object.saveInBackgroundWithBlock({ (success, error) -> Void in
                if (success) {
                    println("data saved")
                    let messageTxt = " \(PFUser.currentUser()?.username!) is requesting referrals for \" \(self.messageTextField.text) \" ."
                   self.SendPushToReferrer(messageTxt)
                } else {
                    println(error)
                }
                
            })
            
            self.navigationController?.popToRootViewControllerAnimated(true)
            
        }

        
    }
}