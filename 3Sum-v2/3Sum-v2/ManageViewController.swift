//
//  ManageViewController.swift
//  3Sum-v2
//
//  Created by Ambrish Verma on 7/6/15.
//  Copyright (c) 2015 com.skylord.com. All rights reserved.
//

import UIKit
import Parse

class ManageViewController: UIViewController {

    @IBOutlet weak var bizPhoneNumber: UITextField!
    
    @IBOutlet weak var bizName: UITextField!
    
    @IBOutlet weak var bizWebLink: UITextField!
    
    @IBOutlet weak var bizAddress: UITextField!
    
    @IBOutlet weak var bizServices: UITextField!
    
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
            self.object = PFObject(className: "Businesses")
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
    
    
    @IBAction func addServices(sender: AnyObject) {
        print("adding services")
        
        var phoneNumber = self.bizPhoneNumber.text
        var name = self.bizName.text
        var webLink = self.bizWebLink.text
        var address = self.bizAddress.text
        var services = self.bizServices.text
        
        if (phoneNumber!.utf16.count < 10 || name!.utf16.count < 3 || services!.utf16.count < 4) {
            let alert = UIAlertView(title: "Invalid", message: "Provide proper phone number, name and services for your businesses", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        } else {
            self.actInd.startAnimating()
            self.object["username"] = PFUser.currentUser()?.username
            self.object["bizPhone"] = phoneNumber
            self.object["bizName"] = name
            self.object["bizAddres"] = address
            let serviceArray = NSMutableArray()
            serviceArray.addObject((services! as String))
            self.object["services"] = serviceArray
            
            self.object.saveInBackgroundWithBlock({ (success, error) -> Void in
                if (success) {
                    print("data saved")
                } else {
                    print(error)
                }
                
            })
            self.navigationController?.popToRootViewControllerAnimated(true)
            
        }

        
        
        
    }
    

}
