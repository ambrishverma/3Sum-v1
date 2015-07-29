//
//  ReferToViewController.swift
//  3Sum-v2
//
//  Created by Ambrish Verma on 7/8/15.
//  Copyright (c) 2015 com.skylord.com. All rights reserved.
//

import UIKit
import AddressBook

extension String {
    var isEmail: Bool {
        let regex = NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .CaseInsensitive, error: nil)
        return regex?.firstMatchInString(self, options: nil, range: NSMakeRange(0, count(self))) != nil
    }
    
    var isPhone: Bool  {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let PHONE_NO_DASH_REFEX = "^\\d{3}\\d{3}\\d{4}$"
        var phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        var phoneTest_noDash = NSPredicate(format: "SELF MATCHES %@", PHONE_NO_DASH_REFEX)
        if (phoneTest.evaluateWithObject(self)
            || phoneTest_noDash.evaluateWithObject(self)
            ){
            return true
        }
        return false
    }

    var extractPhoneNumber: String {
        let str = self
        let number = "".join(str.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet) as [String])
        return number as String
    }
}

class ReferToViewController: UIViewController, AddressBookDelegate {

    @IBOutlet weak var sendToPhoneField: UITextField!
    
    @IBOutlet weak var sendToEmailField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.sendToPhoneField.keyboardType = UIKeyboardType.PhonePad
        self.sendToEmailField.keyboardType = UIKeyboardType.EmailAddress
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func nextAction(sender: AnyObject) {
        
        // user must provide a valid phone or a valid email address
        if ((count(sendToPhoneField.text.utf16) > 0 && (count(sendToPhoneField.text.utf16) < 10  || !sendToPhoneField.text.isPhone)) ||
            (count(sendToEmailField.text.utf16) > 0 && (count(sendToEmailField.text.utf16) < 5 || !sendToEmailField.text.isEmail))
           )
        {
            var alert = UIAlertView(title: "Invalid", message: "Provide proper phone number or email address for your contact", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        } else {
            self.performSegueWithIdentifier("referredBizInfo", sender: self)
        }
        
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "ReferreeLookUp") {
            var addressBookVC: AddressBookViewController = segue.destinationViewController as! AddressBookViewController
            
            self.sendToPhoneField.text = ""
            self.sendToEmailField.text = ""
            addressBookVC.delegate = self
        } else {
            var referredBizVc: ReferredBizViewController = segue.destinationViewController as! ReferredBizViewController
        
            referredBizVc.sendToEmail = sendToEmailField.text
            referredBizVc.sendToPhoneNumber = sendToPhoneField.text.extractPhoneNumber
        }
    }
    
    @IBAction func LookupAddressBook(sender: AnyObject) {
        println("looking up address book for Referree")
        
        self.performSegueWithIdentifier("ReferreeLookUp", sender: self)
    }
    
    
    func ContactSelectedFromAddressBook(abViewController: AddressBookViewController, selectedContact: ABRecordRef) {
        let selectedContactName = ABRecordCopyCompositeName(selectedContact).takeRetainedValue() as String
        println("referree: selected contact: \(selectedContactName)")
        
        if let mobilePhoneNumber = Utilities.GetMobilePhone(selectedContact) {
            println("Mobile phone num: \(mobilePhoneNumber)")
            self.sendToPhoneField.text = mobilePhoneNumber.extractPhoneNumber
        }
        
        if let emailAddress = Utilities.GetEmailAddress(selectedContact) {
            println("Email: \(emailAddress)")
            self.sendToEmailField.text = emailAddress
        }
        
    }


}
