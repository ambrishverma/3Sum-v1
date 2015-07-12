//
//  CustomLoginViewController.swift
//  3Sum-v2
//
//  Created by Ambrish Verma on 7/5/15.
//  Copyright (c) 2015 com.skylord.com. All rights reserved.
//

import UIKit
import Parse

class CustomLoginViewController: UIViewController {

    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.actInd.center = self.view.center
        self.actInd.hidesWhenStopped = true
        self.actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(self.actInd)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    

    @IBAction func loginAction(sender: AnyObject) {
        var username = self.usernameField.text
        var password = self.passwordField.text
        
        if ((count(username.utf16) > 0 && (count(username.utf16) < 10  || !username.isPhone)) ||
        count(password.utf16) < 5)
        {
            var alert = UIAlertView(title: "Invalid", message: "Username must be valid phone number and Password must be longer than 5 characters", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        } else {
            self.actInd.startAnimating()
            PFUser.logInWithUsernameInBackground(username, password: password, block: { (user, error) -> Void in
                
                self.actInd.stopAnimating()
                
                if ((user) != nil) {
                    var alert = UIAlertView(title: "Success", message: "Logged in", delegate: self, cancelButtonTitle: "OK")
                    println("user logged in")
                    self.updateUserRegistration()
                    //alert.show()
                } else {
                    var alert = UIAlertView(title: "failed", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                }
                
            })
            
            updateUserRegistration()
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
     
    }

    
    @IBAction func signUpAction(sender: AnyObject) {
       
        println("signup action")
        self.performSegueWithIdentifier("signup", sender: self)
       
    }
    
    @IBAction func forgotPasswordAction(sender: AnyObject) {
        println("forgot password")
    }
    
    
    func updateUserRegistration() {
        let currentInstallation = PFInstallation.currentInstallation()
        
        NSLog("registering installation for user: \(PFUser.currentUser()?.username)")
       
        if (PFUser.currentUser()?.username != nil) {
            currentInstallation["user"] = PFUser.currentUser()?.username
        }
        
        currentInstallation.saveInBackgroundWithBlock {
            (success, error) -> Void in
            if success {
                NSLog("registered channels for user: \(PFUser.currentUser()?.username)")
            } else {
                NSLog("%@", error!)
            }
            
        }
    }

    
}
