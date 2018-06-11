//
//  AppDelegate.swift
//  TravelApp
//
//  Created by HS on 3/18/18.
//  Copyright © 2018 HS. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import GooglePlaces


//#97b2e4
// UIColor(red:0.60, green:0.68, blue:0.90, alpha:1.0)
let primaryColor = UIColor(red: 210/255, green: 109/255, blue: 180/255, alpha: 1)
let secondaryColor = UIColor(red: 52/255, green: 148/255, blue: 230/255, alpha: 1)
let googleApiKey = "AIzaSyCnlKSC3PcYs0T9NHz6wPGbeTfllCOPjuY"
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
     
        FirebaseApp.configure()
        
        GMSServices.provideAPIKey("AIzaSyC-kopCWIwUpoxl2dqd7xGv-ZZT-ybIKkU")
        GMSPlacesClient.provideAPIKey("AIzaSyDHEWLWpM3-zLalIj2jjOEGojTCJ7hewOg")
       
        UINavigationBar.appearance().backgroundColor =  UIColor(red:0.60, green:0.68, blue:0.90, alpha:1.0) //UIColor(red:0.50, green:0.90, blue:0.99, alpha:1.0)
        UINavigationBar.appearance().tintColor = UIColor(red:0.31, green:0.44, blue:0.67, alpha:1.0) //UIColor(red:0.60, green:0.68, blue:0.90, alpha:1.0) //UIColor(red:0.50, green:0.90, blue:0.99, alpha:1.0) //UIColor(red:0.60, green:0.89, blue:0.93, alpha:1.0)
        
        let authListner = Auth.auth().addStateDidChangeListener{auth, user in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
      
            if user != nil {
                
                    UserService.observeUser(user!.uid){ userProfile in
                    UserService.currentUserProfile = userProfile
                    
                }
                
                let controller = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
                self.window?.rootViewController = controller
                self.window?.makeKeyAndVisible()
            }else {
                
                UserService.currentUserProfile = nil
                //menu screen
                let controller = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
                self.window?.rootViewController = controller
                self.window?.makeKeyAndVisible()
            }
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

