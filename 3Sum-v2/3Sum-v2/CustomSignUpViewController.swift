//
//  CustomSignUpViewController.swift
//  3Sum-v2
//
//  Created by Ambrish Verma on 7/6/15.
//  Copyright (c) 2015 com.skylord.com. All rights reserved.
//

import UIKit
import Parse

class CustomSignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {


    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    

    @IBOutlet weak var profileImageButton: UIButton!
   
    var currentUser: PFObject!
    var currentUserFullName: String = ""
    var currentUserEmail: String = ""
    var imageChanged: Bool = false
    var image: UIImage!
    
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150))

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.actInd.center = self.view.center
        self.actInd.hidesWhenStopped = true
        self.actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.emailTextField.keyboardType = UIKeyboardType.EmailAddress
        view.addSubview(self.actInd)
        
        self.currentUser = PFUser.currentUser()
        
        if (self.currentUser != nil) {

            self.currentUser.fetchIfNeededInBackgroundWithBlock { (result, error) -> Void in
                
                println("Updated User Data")
            
                self.currentUserFullName = self.currentUser.objectForKey("fullname") as! String
                self.currentUserEmail = self.currentUser.objectForKey("email") as! String
            
                if (count(self.currentUserFullName.utf16) > 0) {
                    self.nameTextField.text = self.currentUserFullName
                }
            
                if (count(self.currentUserEmail.utf16) > 0) {
                    self.emailTextField.text = self.currentUserEmail
                }
                
                if (self.currentUser.objectForKey("profileImage") != nil) {
                    var imageFile: PFFile = self.currentUser.objectForKey("profileImage") as! PFFile
                    
                    if (imageFile.isDataAvailable) {
                        imageFile.getDataInBackgroundWithBlock({
                            (imageData: NSData?, error: NSError?) -> Void in
                            if (error == nil) {
                                let image = UIImage(data:imageData!)
                                self.profileImageButton.setImage(image, forState: UIControlState.Normal)
                            } else {
                                println(error?.userInfo)
                            }
                        })
                    }
                }

            
            }
        } else {
            println("found nil user, unexpected!!!")
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
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


    @IBAction func signupAction(sender: AnyObject) {
        var name = self.nameTextField.text
        var email = self.emailTextField.text
    
        // user must provide a valid phone or a valid email address
        if ((count(name.utf16) < 3 ) ||
            (count(email.utf16) > 0 && (count(email.utf16) < 5 || !email.isEmail)) )
        {
            var alert = UIAlertView(title: "Invalid", message: "Provide a valid name and email ", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        } else {
            
            
        println("name: \(name) and email: \(email)")
        
            if ( (name == currentUserFullName) && (email == currentUserEmail) && !self.imageChanged ) {
                println("no changes")
            } else {
                println("updating user info")
                
                self.currentUser.setValue(name, forKey: "fullname")
                self.currentUser.setValue(email, forKey: "email")
                
                
                if (self.image != nil) {
                    println("updating image")
                    let imageData: NSData = UIImageJPEGRepresentation(self.image, 1.0)
                    let imageFile: PFFile = PFFile(name:"ProfilImage.jpg", data:imageData)
                    imageFile.save()
                    self.currentUser.setObject(imageFile, forKey: "profileImage")
                }
                
                // Save updated data
                self.currentUser.saveInBackgroundWithBlock({ (success, error) -> Void in
                    if (success) {
                        println("updated user data saved")
                    } else {
                        println(error)
                    }
                    
                })
                
            }
            
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
    
    @IBAction func updateImage(sender: AnyObject) {
        println("update image")
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        
        presentViewController(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    {
        self.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        if (self.image != nil) {
            self.profileImageButton.setImage(self.image, forState: UIControlState.Normal)
            self.imageChanged = true
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
}
