//
//  ViewReferralsViewController.swift
//  3Sum
//
//  Created by Ambrish Verma on 8/4/15.
//  Copyright (c) 2015 com.skylord.com. All rights reserved.
//

import UIKit
import Parse

class ViewReferralsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    enum ViewOptions: Int {
        case RefIn = 1, RefOut, ReqIn, ReqOut
    }
    
    @IBOutlet weak var listSegmentControl: UISegmentedControl!
    
    
    @IBOutlet weak var referralsTable: UITableView!
    
    
    var referralObjects: NSMutableArray! = NSMutableArray()
    var requestObjects: NSMutableArray! = NSMutableArray()
    var loadOption = ViewOptions.RefIn
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.referralsTable.dataSource = self;
        self.referralsTable.delegate = self;
        //self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.referralsTable.estimatedRowHeight = 200.0
        
        loadRequestedView()

        // Do any additional setup after loading the view.
    }

    func loadRequestedView()
    {
        let selectedOption = self.listSegmentControl.selectedSegmentIndex
        switch (selectedOption) {
            case 0:
                println("Ref In")
                self.loadOption = ViewOptions.RefIn
                self.fetchAllObjectsFromLocalDataStore()
                self.fetchAllObjects()
                break
            case 1:
                println("Ref Out")
                self.loadOption = ViewOptions.RefOut
                self.fetchAllObjectsFromLocalDataStore()
                self.fetchAllObjects()
                break
            case 2:
                println("Req In")
                self.loadOption = ViewOptions.ReqIn
                self.fetchAllRequestsFromLocalDataStore()
                self.fetchAllRequests()
                break
            case 3:
                println("Req Out")
                self.loadOption = ViewOptions.ReqOut
                self.fetchAllRequestsFromLocalDataStore()
                self.fetchAllRequests()
                break
           default:
                println("unknown options")
        }
        println("reloading data")
        self.referralsTable.reloadData()

    }
    
    
    @IBAction func changeSelection(sender: AnyObject) {
        loadRequestedView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        //self.tableView.rowHeight = UITableViewAutomaticDimension;
        //self.tableView.estimatedRowHeight = 200.0
        if (self.loadOption == ViewOptions.RefIn || self.loadOption == ViewOptions.RefOut) {
            println("needed cells: \(self.referralObjects.count)")
            return self.referralObjects.count
        } else if (self.loadOption == ViewOptions.ReqIn || self.loadOption == ViewOptions.ReqOut) {
            println("needed cells: \(self.requestObjects.count)")
            return self.requestObjects.count
        } else {
            return 0
        }
        //return 5
    }
    
    
    func loadReferralsTable(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = referralsTable.dequeueReusableCellWithIdentifier("offerCell", forIndexPath: indexPath) as! OfferViewCell
        
        println("creating cell # \(indexPath.row)")
        cell.clearCell()
        
        // Configure the cell...
        var object: PFObject = self.referralObjects.objectAtIndex(indexPath.row) as! PFObject
        
        cell.nameLabel.text = object["ReferredBizName"] as? String
        var referredByStr = object["ReferrerPhone"] as! String
        var referrerName = object["ReferrerName"] as? String
        if (referrerName == nil) {
            println(" referrer name empty")
        }else {
            if (referrerName != "") {
                referredByStr = referrerName!
            }
        }
        
        cell.referrerPhoneLabel.text = "Referred By: \(referredByStr)"
        cell.phoneLabel.text = object["ReferredBizPhone"] as? String
        cell.emailLabel.text = object["ReferredBizEmail"] as? String
        cell.skillsLabel.text = object["ReferredBizSkills"] as? String
        cell.thumbImageView.image = UIImage(named: "butting_in")
        return cell
    }
    
    func loadRequestsTable(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = referralsTable.dequeueReusableCellWithIdentifier("requestCell", forIndexPath: indexPath) as! RequestTableViewCell
        
        println("creating requests cell # \(indexPath.row)")
        cell.clearCell()
        
        // Configure the cell...
        var object: PFObject = self.requestObjects.objectAtIndex(indexPath.row) as! PFObject
        
        if (loadOption == ViewOptions.ReqIn) {
            cell.senderReceiverNameLabel.text = object["RequesterName"] as? String
        } else if (loadOption == ViewOptions.ReqOut) {
            cell.senderReceiverNameLabel.text = object["ReferrerName"] as? String
        }
        cell.requestMessageTextField.text = object["ReferralRequestMessage"] as? String
 
        cell.senderReceiverImageView.image = UIImage(named: "butting_in")
        return cell
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (self.loadOption == ViewOptions.RefIn || self.loadOption == ViewOptions.RefOut) {
            return loadReferralsTable(tableView, cellForRowAtIndexPath: indexPath)
         } else if (self.loadOption == ViewOptions.ReqIn || self.loadOption == ViewOptions.ReqOut) {
            return loadRequestsTable(tableView, cellForRowAtIndexPath: indexPath)
        }
        
        // by default return referrals
        return loadReferralsTable(tableView, cellForRowAtIndexPath: indexPath)
    }
    
    
    func fetchAllObjectsFromLocalDataStore() {
        
        var query = PFQuery(className: "Referrals")
        query.fromLocalDatastore()
        println("loading local objects")
        println("username: \(PFUser.currentUser()!.username!)")
        var queryKey = ""
        if (self.loadOption == ViewOptions.RefIn) {
            queryKey = "ReferreePhone"
        } else if (self.loadOption == ViewOptions.RefOut) {
            queryKey = "ReferrerPhone"
        } else {
            println("unknown query option")
        }
        query.whereKey(queryKey, equalTo: PFUser.currentUser()!.username!)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if (error == nil) {
                var temp: NSArray = (objects as NSArray?)!
                self.referralObjects = temp.mutableCopy() as! NSMutableArray
                println("fetch locl objects: \(self.referralObjects.count)")
                self.referralsTable.reloadData()
            } else {
                println(error?.userInfo)
            }
        }
    }
    
    func fetchAllObjects() {
        PFObject.unpinAllObjectsInBackgroundWithBlock(nil)
        println("fetching all objects")
        var query = PFQuery(className: "Referrals")
        var queryKey = ""
        if (self.loadOption == ViewOptions.RefIn) {
            queryKey = "ReferreePhone"
        } else if (self.loadOption == ViewOptions.RefOut) {
            queryKey = "ReferrerPhone"
        } else {
            println("unknown query option")
        }
        query.whereKey(queryKey, equalTo: PFUser.currentUser()!.username! )
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if (error == nil) {
                PFObject.pinAll(objects)
                self.fetchAllObjectsFromLocalDataStore()
            } else {
                println(error?.userInfo)
            }
        }
    }

    func fetchAllRequestsFromLocalDataStore() {
        
        var query = PFQuery(className: "RefRequests")
        query.fromLocalDatastore()
        println("loading local requests")
        println("username: \(PFUser.currentUser()!.username!)")
        var queryKey = ""
        if (self.loadOption == ViewOptions.ReqIn) {
            queryKey = "ReferrerPhone"
        } else if (self.loadOption == ViewOptions.ReqOut) {
            queryKey = "RequesterPhone"
        } else {
            println("unknown query option")
        }
        query.whereKey(queryKey, equalTo: PFUser.currentUser()!.username!)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if (error == nil) {
                var temp: NSArray = (objects as NSArray?)!
                self.requestObjects = temp.mutableCopy() as! NSMutableArray
                println("fetch locl requests: \(self.requestObjects.count)")
                self.referralsTable.reloadData()
            } else {
                println(error?.userInfo)
            }
        }
    }
    
    func fetchAllRequests() {
        PFObject.unpinAllObjectsInBackgroundWithBlock(nil)
        println("fetching all objects")
        var query = PFQuery(className: "RefRequests")
        var queryKey = ""
        if (self.loadOption == ViewOptions.ReqIn) {
            queryKey = "ReferrerPhone"
        } else if (self.loadOption == ViewOptions.ReqOut) {
            queryKey = "RequesterPhone"
        } else {
            println("unknown query option")
        }
        query.whereKey(queryKey, equalTo: PFUser.currentUser()!.username! )
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if (error == nil) {
                PFObject.pinAll(objects)
                self.fetchAllRequestsFromLocalDataStore()
            } else {
                println(error?.userInfo)
            }
        }
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
