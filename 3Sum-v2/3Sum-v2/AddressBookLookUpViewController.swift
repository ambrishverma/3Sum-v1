
import UIKit
import AddressBook
import AddressBookUI
import CoreFoundation


class Utilities {
    static func GetMobilePhone(abEntry: ABRecordRef) -> String? {
        let phoneNumbers: ABMultiValueRef = ABRecordCopyValue(abEntry, kABPersonPhoneProperty).takeRetainedValue() as ABMultiValueRef
        for(var index:CFIndex = 0; index < ABMultiValueGetCount(phoneNumbers); ++index) {
            let unmanagedPhoneLabel = ABMultiValueCopyLabelAtIndex(phoneNumbers, index)
            let phoneLabel: String = Unmanaged.fromOpaque(
                unmanagedPhoneLabel.toOpaque()).takeUnretainedValue() as NSObject as! String
            
            let compareResult: CFComparisonResult = CFStringCompare(phoneLabel, kABPersonPhoneMobileLabel, CFStringCompareFlags.CompareCaseInsensitive)
            
            if (compareResult == CFComparisonResult.CompareEqualTo) {
                let unmanagedPhoneNumber = ABMultiValueCopyValueAtIndex(phoneNumbers, index)
                let phoneNumber: String = Unmanaged.fromOpaque(
                    unmanagedPhoneNumber.toOpaque()).takeUnretainedValue() as NSObject as! String

                return phoneNumber
            }
            
        }
        return nil
    }
    
    
    static func GetEmailAddress(abEntry: ABRecordRef) -> String? {
        let emails: ABMultiValueRef = ABRecordCopyValue(abEntry, kABPersonEmailProperty).takeRetainedValue() as ABMultiValueRef
        if (ABMultiValueGetCount(emails) > 0) {
            let index = 0 as CFIndex
            let emailAddress = ABMultiValueCopyValueAtIndex(emails, index).takeRetainedValue() as? String
           // println(emailAddress)
            return emailAddress
        } else {
            println("No email address")

        }
        return nil
    }

    
}

protocol AddressBookDelegate: class{
    func ContactSelectedFromAddressBook(abViewController: AddressBookViewController, selectedContact: ABRecordRef);
}

class AddressBookViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var addressBook: ABAddressBook!
    //let addressBookRef: ABAddressBook = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
    var names:[String]?
    var ABRefs:[ABRecordRef]?
  
    @IBOutlet weak var contactSearchBar: UISearchBar!
    
    @IBOutlet weak var namesTableView: UITableView!
    
    weak var delegate: AddressBookDelegate?
    
    private func _initalizeAddressBook() {
        var err : Unmanaged<CFError>? = nil
        var addressBookPointer = ABAddressBookCreateWithOptions(nil, &err)
        addressBook = addressBookPointer?.takeRetainedValue()
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        _initalizeAddressBook()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _initalizeAddressBook()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.namesTableView.dataSource = self;
        self.namesTableView.delegate = self;
        self.contactSearchBar.delegate = self;
        
        self.namesTableView.rowHeight = UITableViewAutomaticDimension;
        self.namesTableView.estimatedRowHeight = 40.0
        self.getABPermissions()
        //self.beginContactSearch()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchBarSearchButtonClicked (searchBar)
    }
    
    
    func searchBarSearchButtonClicked( searchBar: UISearchBar)
    {
        var searchContactName = contactSearchBar.text
        println("looking for: \(searchContactName)")

        if let contactEntry: ABRecordRef = searchContactRecord(searchContactName) {
            println(" found contact")
        } else {
            println(" not found ")
        }
    }

    
    func searchContactRecord(searchName: String) -> ABRecordRef? {

     //   let allContacts = ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue() as Array
        let records = ABAddressBookCopyArrayOfAllPeople(self.addressBook).takeRetainedValue() as NSArray as [ABRecord]
        var contactEntry: ABRecordRef?
        names?.removeAll(keepCapacity: true)
        ABRefs?.removeAll(keepCapacity: true)
        var count = 0
        for record in records {
            let object = ABRecordCopyCompositeName(record)
            if (object == nil || object.toOpaque() == nil) {
                println("nil")
            } else {
                let name = object.takeRetainedValue() as NSString
                    if (name.lowercaseString.rangeOfString(searchName.lowercaseString) != nil) {
                        println("found \(name).")
                        names!.append(name as String)
                        ABRefs!.append(record as ABRecordRef)
                    }
            }
       }
        namesTableView.reloadData()
        return contactEntry
    }
    
//    @IBAction func didTapFetch(sender: AnyObject) {
    func getABPermissions() {
        switch (ABAddressBookGetAuthorizationStatus()){
        case .NotDetermined:
            ABAddressBookRequestAccessWithCompletion(addressBook) {
                success, error in
                if success {
                    self.beginContactSearch()
                } else {
                    NSLog("Restricted")
                }
            }
        case .Denied, .Restricted:
            NSLog("Restricted")
        case .Authorized:
            self.beginContactSearch()
        }
    }
    
    // loads all contacts
    func beginContactSearch(){
        let records = ABAddressBookCopyArrayOfAllPeople(self.addressBook).takeRetainedValue() as NSArray as [ABRecord]
        names = Array()
        ABRefs = Array()
        var count = 0
        for record in records {
            let object = ABRecordCopyCompositeName(record)
            if (object == nil || object.toOpaque() == nil) {
                println("nil")
            } else {
                var name = object.takeRetainedValue() as NSString
                println("found: \(name)")
                names!.append(name as String)
                ABRefs!.append(record as ABRecordRef)
                print("\(count)")
                count = count+1
            }
        }
        namesTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (self.names == nil) {
            return 0;
        }
        
        println("Creating \(self.names!.count) cells")
        return self.names!.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("selected: \(indexPath.row)")
        
        println("name selected: \(names![indexPath.row])")
        self.delegate?.ContactSelectedFromAddressBook(self, selectedContact: ABRefs![indexPath.row])

    
        
        if let navigationController = self.navigationController
        {
            navigationController.popViewControllerAnimated(true)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = namesTableView.dequeueReusableCellWithIdentifier("addressBookCell") as! AddressBookTableViewCell
        println("creating cell# \(indexPath.row) for \(names![indexPath.row])")
        cell.textLabel!.text = names![indexPath.row]
        return cell
    }
}