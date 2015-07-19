//
//  RedeemTableViewController.swift
//  3Sum-v2
//
//  Created by Ambrish Verma on 7/9/15.
//  Copyright (c) 2015 com.skylord.com. All rights reserved.
//

import UIKit
import Parse

class RedeemTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {

    var referralObjects: NSMutableArray! = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        //self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 200.0
        
        // load offers
        println("loading offers")
        self.fetchAllObjectsFromLocalDataStore()
        self.fetchAllObjects()
        println("reloading data")
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        //self.tableView.rowHeight = UITableViewAutomaticDimension;
        //self.tableView.estimatedRowHeight = 200.0
      
        println("needed cells: \(self.referralObjects.count)")
        return self.referralObjects.count
        //return 5
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("offerCell", forIndexPath: indexPath) as! OfferViewCell
        
        println("creating cell # \(indexPath.row)")
        cell.clearCell()
        
        // Configure the cell...
        var object: PFObject = self.referralObjects.objectAtIndex(indexPath.row) as! PFObject
        
        cell.nameLabel.text = object["ReferredBizName"] as? String
        let referredByStr = object["ReferrerPhone"] as! String
        cell.referrerPhoneLabel.text = "Referred By: \(referredByStr)"
        cell.phoneLabel.text = object["ReferredBizPhone"] as? String
        cell.emailLabel.text = object["ReferredBizEmail"] as? String
        cell.skillsLabel.text = object["ReferredBizSkills"] as? String
        cell.thumbImageView.image = UIImage(named: "butting_in")

/*        cell.addressLabel.text = object["ReferredBizName"] as? String
        cell.offerDealLabel.text = object["ReferredBizName"] as? String
        cell.distanceLabel.text = object["ReferredBizName"] as? String

        
        
        if (object.objectForKey("image") != nil) {
            var imageFile: PFFile = object.objectForKey("image") as! PFFile
            
            if (imageFile.isDataAvailable) {
                imageFile.getDataInBackgroundWithBlock({
                    (imageData: NSData?, error: NSError?) -> Void in
                    if (error == nil) {
                        let image = UIImage(data:imageData!)
                        cell.masterImageView.image = image
                    } else {
                        println(error?.userInfo)
                    }
                })
            }
        }
*/
        
        return cell
    }
    
    
    func fetchAllObjectsFromLocalDataStore() {
        
        var query = PFQuery(className: "Referrals")
        query.fromLocalDatastore()
        println("loading local objects")
        println("username: \(PFUser.currentUser()!.username!)")
        query.whereKey("ReferreePhone", equalTo: PFUser.currentUser()!.username!)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if (error == nil) {
                var temp: NSArray = (objects as NSArray?)!
                self.referralObjects = temp.mutableCopy() as! NSMutableArray
                println("fetch locl objects: \(self.referralObjects.count)")
                self.tableView.reloadData()
            } else {
                println(error?.userInfo)
            }
        }
    }
    
    func fetchAllObjects() {
        PFObject.unpinAllObjectsInBackgroundWithBlock(nil)
        println("fetching all objects")
        var query = PFQuery(className: "Referrals")
        query.whereKey("ReferreePhone", equalTo: PFUser.currentUser()!.username! )
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if (error == nil) {
                PFObject.pinAll(objects)
                self.fetchAllObjectsFromLocalDataStore()
            } else {
                println(error?.userInfo)
            }
        }
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
