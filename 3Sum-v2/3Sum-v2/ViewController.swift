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
        if (PFUser.currentUser() == nil) {
            self.loginSignUpButton.hidden = false;
            self.logoutButton.hidden = true;
            self.loginViewController.fields = PFLogInFields.UsernameAndPassword | PFLogInFields.LogInButton | PFLogInFields.SignUpButton | PFLogInFields.PasswordForgotten | PFLogInFields.DismissButton
            
            var loginLogoTitle = UILabel()
            loginLogoTitle.text = "3-Sum Login"
            self.loginViewController.logInView!.logo = loginLogoTitle
            
            let logo = UIImage(named: "3-Sum-logo");

            let imageView = UIImageView(image:logo)
            imageView.frame.size.width = 100;
            imageView.frame.size.height = 100;
            imageView.frame.origin = CGPoint(x: 110, y: 50)
            self.loginViewController.logInView!.addSubview(imageView)
            
            self.loginViewController.delegate = self
            
            var signUpLogoTitle = UILabel()
            signUpLogoTitle.text = "3-Sum Sign Up"
            self.signUpViewController.signUpView!.logo = signUpLogoTitle
            self.signUpViewController.signUpView!.addSubview(imageView)
            
            self.signUpViewController.delegate = self
            
            
            self.loginViewController.signUpController = self.signUpViewController
            
        } else {
            println("user already logged in")
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
        
        println("user logged in")
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        println("failed to login")
    }
    
    
    // MARK: Parse Signup
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        println("failed to signup")
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
        println("user dismissed sign up")
        
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
        println("refer action")
        self.performSegueWithIdentifier("referTo", sender: self)
    }
    
    @IBAction func redeemAction(sender: AnyObject) {
        println("redeem action")
        self.performSegueWithIdentifier("redeem", sender: self)
    }
    
    @IBAction func manageAction(sender: AnyObject) {
        println("manage services")
        self.performSegueWithIdentifier("manage", sender: self)
    }
    
    
    
}

