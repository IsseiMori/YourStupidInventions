//
//  AppDelegate.swift
//  YourStupidInventions
//
//  Created by MoriIssei on 8/25/18.
//  Copyright © 2018 IsseiMori. All rights reserved.
//

import UIKit
import Parse

// global variable for maintain login status
var isLoggedIn = false

// languages of posts to show
var selectedLanguages: [String] = []

// custom UIColors for this app
let customColorYellow: UIColor = UIColor(red: 255.0 / 255.0, green: 189.0 / 255.0, blue: 0.0 / 255.0, alpha: 1) // #ffbd00
let customColorBrown: UIColor = UIColor(red: 73/255, green: 72/255, blue: 62/255, alpha: 1) // #49483e
let customColorLightBlack: UIColor = UIColor(red: 37.0 / 255.0, green: 39.0 / 255.0, blue: 42.0 / 255.0, alpha: 1) // #25272a
// light gray #d3d3d3

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        // Configuration of using Parse code in Back4App
        let parseConfig = ParseClientConfiguration { (ParseMutableClientConfiguration) in
            
            // Accessing Heroku App using id & keys
            ParseMutableClientConfiguration.applicationId = "T2JD8e6uEAxbSCLXBUMXb7WUQxC4B75J8oBlS4cm"
            ParseMutableClientConfiguration.clientKey = "tBkdOLH6YpmtpViV4yjIRJbB1q3tks8UuE4957bx"
            ParseMutableClientConfiguration.server = "https://parseapi.back4app.com/"
        }
        
        // Initialize Parse with configuration
        Parse.initialize(with: parseConfig)
        
        // call login function
        login()
        
        // color of window
        window?.backgroundColor = .white
        
        // language setting
        // get device saved langs
        let langSet = UserDefaults.standard.stringArray(forKey: "selectedLanguages")
        // if this is the first time using app, set device default language as selected languages
        if langSet == nil {
            if Locale.current.languageCode!.hasPrefix("jp") {
                selectedLanguages.append("jp")
            } else {
                selectedLanguages.append("en")
            }
            // save
            UserDefaults.standard.set(selectedLanguages, forKey: "selectedLanguages")
            UserDefaults.standard.synchronize()
        } else {
            // after 2nd time, move langs to selectedLanguages
            selectedLanguages = langSet!
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
    

    func login() {
        
        // remember user's login
        let username: String? = UserDefaults.standard.string(forKey: "username")
        
        // if logged in
        if username != nil {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let myTabBar = storyboard.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController
            window?.rootViewController = myTabBar
            isLoggedIn = true
        }
    }

}

