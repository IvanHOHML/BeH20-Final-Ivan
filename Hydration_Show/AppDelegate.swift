//
//  SceneDelegate.swift
//  Hydration_Show
//
//  Created by  Ho Ivan on 9/1/20.
//  Copyright © 2020  Ho Ivan. All rights reserved.
//
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

// JASON - GET A FLAG IF USER IS LAUNCHING THE FIRST TIME

//    var optionallyStoreTheFirstLaunchFlag = false
//    let isFirstLaunch = UserDefaults.isFirstLaunch()
    let defaults = UserDefaults.standard
    var appBrain = AppBrain()
    var dateOfTerminate : String = ""
//
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print("dateOfTerminate : \(dateOfTerminate)")   //DEBUG
        appBrain.checkDate()
        
        let df = DateFormatter()
        df.timeZone = .current
        df.dateFormat = "yyyy-MM-dd"
        dateOfTerminate = df.string(from: Date())
        
        self.defaults.set(self.dateOfTerminate, forKey: "DateOfTerminate")
        print ("dateOfTerminate is Saved : \(dateOfTerminate)") //DEBUG

        //optionallyStoreTheFirstLaunchFlag = UserDefaults.isFirstLaunch()
        // Override point for customization after application launch.
        return true
    }


     //MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        
    }


}

//extension UserDefaults {
//    // check for is first launch - only true on first invocation after app install, false on all further invocations
//    // Note: Store this value in AppDelegate if you have multiple places where you are checking for this flag
//    static func isFirstLaunch() -> Bool {
//        let hasBeenLaunchedBeforeFlag = "hasBeenLaunchedBeforeFlag"
//        let isFirstLaunch = !UserDefaults.standard.bool(forKey: hasBeenLaunchedBeforeFlag)
//        if (isFirstLaunch) {
//            UserDefaults.standard.set(true, forKey: hasBeenLaunchedBeforeFlag)
//            UserDefaults.standard.synchronize()
//        }
//        return isFirstLaunch
//    }
//}
