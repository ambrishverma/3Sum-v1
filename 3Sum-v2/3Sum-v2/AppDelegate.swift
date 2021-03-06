//
//  AppDelegate.swift
//  3Sum-v2
//
//  Created by Ambrish Verma on 7/5/15.
//  Copyright (c) 2015 com.skylord.com. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool { 

        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId("x4HCE9yXS6UzKG5CZb9fXeY7r9c6rPcB3bJsZGws",
            clientKey: "I3pbYNOtXRt4KwqLR9BmYtaPeof71DJpti65noaD")
        
        // Register for Push Notitications, if running iOS 8
        if application.respondsToSelector("registerUserNotificationSettings:") {
            
            let types:UIUserNotificationType = (.Alert | .Badge | .Sound)
            let settings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: nil)
            
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
            
        }
  /*      else {
            // Register for Push Notifications before iOS 8
            application.registerForRemoteNotificationTypes(.Alert | .Badge | .Sound)
        }
   */     
        return true
    }
    
    func application(application: UIApplication,didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        println("successfully registered for PN: \(deviceToken)")
        PFPush.storeDeviceToken(deviceToken)
        
        let currentInstallation = PFInstallation.currentInstallation()
        
        // broadcast channel
        currentInstallation.addUniqueObject("", forKey: "channels")
        // referral channel
        currentInstallation.addUniqueObject("referrals", forKey: "channels")
 
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
        
        //PFPush.subscribeToChannelInBackground("", block: { (result , error) -> Void in
        //    println("subscirbed to channel: \(error)")
        //})
    }
    
    //Called if unable to register for APNS.
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        
        println("failed to register for PN")
        println(error)
        
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
    }
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

