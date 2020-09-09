//
//  UserProfile.swift
//  Hydration Profile
//
//  Created by Jason So on 1/9/2020.
//  Copyright © 2020 Jason So. All rights reserved.
//

import Foundation

struct UserProfile : Codable {
    
    let gender : String
    let age : Int
    let height : Double
    let weight : Double
    let activity : String
    
    var waterTarget : Int = 0
    
    var activityLevel : Int {
        get {
            switch self.activity {
            case "0" :
                return 0
            case "1" :
                return 1
            case "2" :
                return 2
            default :
                return 3
            }
        }
    }
    
    var waterDrank : Int = 0
    
    var waterPercentage : Double {
        get {
            return Double(waterDrank)/Double(waterTarget)*100
        }
    }

    mutating func setWaterTarget(userSet: Bool, userSetValue: Int){
            if userSet == false {
                self.waterTarget = Int((1.47*self.weight+Double(12*self.activityLevel))*22.18)
            } else {
                self.waterTarget = userSetValue
            }
    }
    
    var profileIsSet : Bool = false
    
}
