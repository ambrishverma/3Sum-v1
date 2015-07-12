//
//  ViewController.swift
//  3Sum-v2
//
//  Created by Ambrish Verma on 7/5/15.
//  Copyright (c) 2015 com.skylord.com. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    
    @IBOutlet weak var mainLogoImageView: UIImageView!
    @IBOutlet weak var loginSignUpButton: UIButton!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    var loginViewController: PFLogInViewController = PFLogInViewController()
    var signUpViewController: PFSignUpViewController = PFSignUpViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.mainLogoImageView.image = UIImage(named: "3-sum")
        if (PFUser.currentUser() == nil) {
            self.loginSignUpButton.hidden = false;
            self.logoutButton.hidden = true;
            self.loginViewController.fields = [PFLogInFields.UsernameAndPassword, PFLogInFields.LogInButton, PFLogInFields.SignUpButton, PFLogInFields.PasswordForgotten, PFLogInFields.DismissButton]
            
            let loginLogoTitle = UILabel()
            loginLogoTitle.text = "3-Sum Login"
            self.loginViewController.logInView!.logo = loginLogoTitle
            
            let logo = UIImage(named: "3-Sum-logo");

            let imageView = UIImageView(image:logo)
            imageView.frame.size.width = 100;
            imageView.frame.size.height = 100;
            imageView.frame.origin = CGPoint(x: 110, y: 50)
            self.loginViewController.logInView!.addSubview(imageView)
            
            self.loginViewController.delegate = self
            
            let signUpLogoTitle = UILabel()
            signUpLogoTitle.text = "3-Sum Sign Up"
            self.signUpViewController.signUpView!.logo = signUpLogoTitle
            self.signUpViewController.signUpView!.addSubview(imageView)
            
            self.signUpViewController.delegate = self
            
            
            self.loginViewController.signUpController = self.signUpViewController
            
        } else {
            print("user already logged in")
            self.loginSignUpButton.hidden = true;
            self.logoutButton.hidden = false;
        }
    }

    
    // MARK: Parse Login
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {


        if (!username.isEmpty || !password.isEmpty) {
             return true
        } else {
            return false
        }
        
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        
        print("user logged in")
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        print("failed to login")
    }
    
    
    // MARK: Parse Signup
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        print("failed to signup")
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
        print("user dismissed sign up")
        
    }
    
    // MARK: Actions
    @IBAction func simpleAction(sender: AnyObject) {
        self.presentViewController(self.loginViewController, animated: true, completion: nil)
    }
    
    @IBAction func customAction(sender: AnyObject) {
        self.performSegueWithIdentifier("login", sender: self)
    }
    
    @IBAction func logoutAction(sender: AnyObject) {
        PFUser.logOut()
        self.logoutButton.hidden = false;
    }
    
    @IBAction func referAction(sender: AnyObject) {
        print("refer action")
        self.performSegueWithIdentifier("referTo", sender: self)
    }
    
    @IBAction func redeemAction(sender: AnyObject) {
        print("redeem action")
        self.performSegueWithIdentifier("redeem", sender: self)
    }
    
    @IBAction func manageAction(sender: AnyObject) {
        print("manage services")
        self.performSegueWithIdentifier("manage", sender: self)
    }
    
    
    
}

