//
//  WaterBrain.swift
//  Waterproject
//
//  Created by Tigger on 1/9/2020.
//  Copyright © 2020 Tigger. All rights reserved.
//

import Foundation

struct AppBrain {
    
    var userProfile = UserProfile(gender: "", age: 0, height: 0.0, weight: 0.0, activity: "")
    let defaults = UserDefaults.standard
    
    mutating func checkDate() {
        
        let df = DateFormatter()
        df.timeZone = .current
        df.dateFormat = "yyyy-MM-dd"
        let dateToday = df.string(from: Date())
        
        
        
        let dateOfTerminate = defaults.string(forKey: "DateOfTerminate")
        //print("Today's date : \(dateToday) Date of Terminate : \(dateOfTerminate)") //DEBUG
        
        if dateToday == dateOfTerminate {
            //print ("checkDate executed: Date same") //DEBUG
            return
        } else {
            dailyRefresh()
            //print ("checkDate executed: Date Diff") //DEBUG
        }
        
    }
    
    mutating func dailyRefresh() {
        //print("dailyRefresh executed") //DEBUG
        if let userProf = downloadData() {
            userProfile = userProf
        }
        userProfile.waterDrank = 0
        updateData(userProfile)
    }
    
    // JASON - FUNCTION FOR DOWNLOADING LOCAL DATA
    func downloadData() -> UserProfile? {
    if let savedProfile = defaults.object(forKey: "UserProfile") as? Data {
            let decoder = JSONDecoder()
            if let userProfile = try? decoder.decode(UserProfile.self, from: savedProfile) {
                return userProfile
            }
        }
        return nil
    }
    
    
    
    // JASON - FUNCTION FOR UPDATING LOCAL DATA
    func updateData(_ profile: UserProfile) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(profile) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "UserProfile")
        }
    }
    
}
