//
//  ReferredBizViewController.swift
//  3Sum-v2
//
//  Created by Ambrish Verma on 7/8/15.
//  Copyright (c) 2015 com.skylord.com. All rights reserved.
//

import UIKit
import AddressBook


class ReferredBizViewController: UIViewController, AddressBookDelegate {

    var sendToPhoneNumber: String = ""
    var sendToEmail: String = ""
    
    @IBOutlet weak var referredBizNameField: UITextField!
    
    @IBOutlet weak var referredPhoneNumberField: UITextField!    
    
    @IBOutlet weak var referredEmailField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.referredPhoneNumberField.keyboardType = UIKeyboardType.PhonePad
        self.referredEmailField.keyboardType = UIKeyboardType.EmailAddress
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func nextAction(sender: AnyObject) {
        if (count(referredBizNameField.text.utf16) < 2 ||
            (count(referredPhoneNumberField.text.utf16) > 0 && (count(referredPhoneNumberField.text.utf16) < 10  || !referredPhoneNumberField.text.isPhone)) ||
            (count(referredEmailField.text.utf16) > 0 && (count(referredEmailField.text.utf16) < 5 || !referredEmailField.text.isEmail))
         )
        {
            var alert = UIAlertView(title: "Invalid", message: "Provide business/person name and a valid phone number/email address you are referring", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        } else {
            self.performSegueWithIdentifier("referredSkills", sender: self)
        }
        
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "BizLookUp") {
            var addressBookVC: AddressBookViewController = segue.destinationViewController as! AddressBookViewController
            self.referredPhoneNumberField.text = ""
            self.referredEmailField.text = ""
            addressBookVC.delegate = self
        } else {
            var referredSkillsVc: ReferredSkillsViewController = segue.destinationViewController as! ReferredSkillsViewController

            referredSkillsVc.refData.referreePhone = sendToPhoneNumber
            referredSkillsVc.refData.referreeEmail = sendToEmail
        
            referredSkillsVc.refData.referredBizPhone = referredPhoneNumberField.text.extractPhoneNumber
            referredSkillsVc.refData.referredBizEmail = referredEmailField.text
            referredSkillsVc.refData.referredBizName = referredBizNameField.text
        }
    }


    @IBAction func LookupAddressBook(sender: AnyObject) {
        println("looking up address book for referred")
        
        self.performSegueWithIdentifier("BizLookUp", sender: self)
    }
    
    
    func ContactSelectedFromAddressBook(abViewController: AddressBookViewController, selectedContact: ABRecordRef) {
        let selectedContactName = ABRecordCopyCompositeName(selectedContact).takeRetainedValue() as String
        println("referree: selected contact: \(selectedContactName)")
        self.referredBizNameField.text = selectedContactName
        
        if let mobilePhoneNumber = Utilities.GetMobilePhone(selectedContact) {
            println("Mobile phone num: \(mobilePhoneNumber)")
            self.referredPhoneNumberField.text = mobilePhoneNumber.extractPhoneNumber
        }
        
        if let emailAddress = Utilities.GetEmailAddress(selectedContact) {
            println("Email: \(emailAddress)")
            self.referredEmailField.text = emailAddress
        }
        
    }
    
}
