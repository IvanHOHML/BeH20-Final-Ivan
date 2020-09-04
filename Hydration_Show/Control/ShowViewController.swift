//
//  ViewController.swift
//  Hydration_Show
//
//  Created by  Ho Ivan on 9/1/20.
//  Copyright © 2020  Ho Ivan. All rights reserved.
//

import UIKit
import AVFoundation

class ShowViewController: UIViewController,UNUserNotificationCenterDelegate {
    // Initialize all the UI Comonents
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var buttonS: UIButton!
    @IBOutlet weak var buttonM: UIButton!
    @IBOutlet weak var buttonL: UIButton!
    @IBOutlet weak var sliderBar: UISlider!
    @IBOutlet weak var buttonConfirm: UIButton!
    @IBOutlet weak var sliderValueLabel: UILabel!
    @IBOutlet weak var cupSelectImage: UIImageView!
    @IBOutlet weak var undoBtn: UIButton!
    
    @IBOutlet weak var tapMeLabel: UILabel!
    @IBOutlet weak var upperLabel: UILabel!
    @IBOutlet weak var lineImage: UIImageView!
    @IBOutlet weak var lowerLabel: UILabel!
    
    
    
    // Initialize controller variables
    var tapMeTrue : Bool = false
    var imageNameStr = ""
    var confirmDrinking : [Int] = []
    var audioPlayerDrink = AVAudioPlayer()
    var audioPlayerLV = AVAudioPlayer()
    var audioDrinkSound =  URL(fileURLWithPath: Bundle.main.path(forResource: "DrinkSound", ofType: "mp3")!)
    var audioLVSound = URL(fileURLWithPath: Bundle.main.path(forResource: "LVSound", ofType: "mp3")!)

    var scheduledNotiHour = [09,11,13,15,17,19,21]
    var userProfile = UserProfile(gender: "", age: 0, height: 0.0, weight: 0.0, activity: "", waterDrank: 0)

    var defaults = UserDefaults.standard
    

    // Initialize viewDidLoad function
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor(red: CGFloat(46)/255.0, green: CGFloat(196)/255.0,blue: CGFloat(182)/255.0, alpha: 1.0)
        sliderBar.value = 250
        sliderBar.maximumValue = 1000
        sliderBar.minimumValue = 0
        userProfile = downloadData()!
        // Assign value from struct
        percentLabel.text = String(Int(userProfile.waterPercentage)) + "%"
        if userProfile.gender == "Male" {
            imageNameStr = "Male_000"
        } else {
            imageNameStr = "Female_000"
        }
        super.viewDidLoad()
    
        for y in scheduledNotiHour {                   //Scheduling Notification
            print("\(y) notification is scheduled.")
            notification(hour:y,minutes:00)
        }
        updateIconLabel ()
        updateIcon()
        print("\(userProfile.gender) : ShowViewController")
        print(audioDrinkSound)
        do {
            audioPlayerDrink = try AVAudioPlayer(contentsOf: audioDrinkSound)
            audioPlayerLV = try AVAudioPlayer(contentsOf: audioLVSound)
        } catch {
            print(error)
        }
        undoBtn.isHidden = true
    }

    
    
    // Func to update slider value
    @IBAction func btnUpdate(_ sender: UIButton) {
        tapMeTrue = false
        updateIconLabel ()
        if sender.currentTitle == "S" {
            //buttonS.isSelected =
            sliderBar.value = 100
            cupSelectImage.image = UIImage(named: "CupSelect_Small")
        } else if sender.currentTitle == "M" {
            sliderBar.value = 250
            cupSelectImage.image = UIImage(named: "CupSelect_Medium")
        } else if sender.currentTitle == "L" {
            sliderBar.value = 500
            cupSelectImage.image = UIImage(named: "CupSelect_Large")
        }
        sliderValueLabel.text = String(format: "%.0f", sliderBar.value) + " ml"
    }
    
    // Func to update label next to slider when value changed
    @IBAction func sliderChange(_ sender: UISlider) {
        tapMeTrue = false
        updateIconLabel ()
        sliderValueLabel.text = String(format: "%.0f", sliderBar.value) + " ml"
    }
    
    // Func to update Percentage label when button (logo) was clicked
    @IBAction func confirmBtn(_ sender: UIButton) {
        userProfile.waterDrank += Int(sliderBar.value)
        tapMeTrue = true
        updateIconLabel ()
        updateIcon()
        percentLabel.text = String(Int(userProfile.waterPercentage)) + "%"
        confirmDrinking.append(Int(sliderBar.value))
        updateData(userProfile)
        print(confirmDrinking)
    }
    
    func updateIcon() {
        undoBtn.isHidden = false
        // find out which image we should use
        var newImageStr = ""
        // Male or Female?
        if userProfile.gender == "Male" {
            newImageStr = "Male_"
        } else {
            newImageStr = "Female_"
        }
        // What is the current % water fulfilled?
        switch userProfile.waterPercentage {
            case let waterPer where waterPer >= 100:
                newImageStr = newImageStr + "100"
            case let waterPer where waterPer >= 90:
                newImageStr = newImageStr + "090"
            case let waterPer where waterPer >= 80:
                newImageStr = newImageStr + "080"
            case let waterPer where waterPer >= 70:
                newImageStr = newImageStr + "070"
            case let waterPer where waterPer >= 60:
                newImageStr = newImageStr + "060"
            case let waterPer where waterPer >= 50:
                newImageStr = newImageStr + "050"
            case let waterPer where waterPer >= 40:
                newImageStr = newImageStr + "040"
            case let waterPer where waterPer >= 30:
                newImageStr = newImageStr + "030"
            case let waterPer where waterPer >= 20:
                newImageStr = newImageStr + "020"
            case let waterPer where waterPer >= 10:
                newImageStr = newImageStr + "010"
            default:
                newImageStr = newImageStr + "000"
        }
        
        // Debug print : Check if the image is called correctly
        if newImageStr == "Male_100" || newImageStr == "Female_100" {
            audioPlayerLV.play()
        } else {
            audioPlayerDrink.play()
        }
        imageNameStr = newImageStr
        buttonConfirm.setImage(UIImage(named: newImageStr), for: .normal)
    }
    
    @IBAction func undoBtnPressed(_ sender: UIButton) {
        
        if confirmDrinking.last == nil {
            //audioStop.play()
        } else {
            if let lastInput = confirmDrinking.last {
                userProfile.waterDrank -= lastInput
                updateData(userProfile)
                updateIcon()
                updateIconLabel ()
                percentLabel.text = String(Int(userProfile.waterPercentage)) + "%"
                confirmDrinking.removeLast()
                print(confirmDrinking)
                if confirmDrinking.count == 0 {
                    sender.isHidden = true
                }
            }
        }
        
    }
    
    @IBAction func setProfile(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toProfile", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProfile" {
            let destinationVC = segue.destination as! ProfileViewController
            destinationVC.userProfile = userProfile
        }
    }
    
    
    // JASON - FUNCTION FOR UPDATING LOCAL DATA
    func updateData(_ profile: UserProfile) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(profile) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "UserProfile")
        }
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
    
    func notification(hour:Int, minutes: Int) {
        let hourString = String(hour)
        print("NOTIFICATION CALLED")
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minutes
        
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                self.registerCategory()
                
                self.scheduleNotification(event: "Drinking Reminder", time: dateComponents, hourString: hourString)
                
            }
        }
    }
    
    func registerCategory() -> Void{
        
        print("REGISTERCATEGORY CALLED")
        let drink = UNNotificationAction(identifier: "drink", title: "Drink", options: [])
        let clear = UNNotificationAction(identifier: "clear", title: "Clear", options: [])
        let category : UNNotificationCategory = UNNotificationCategory.init(identifier: "CALLINNOTIFICATION", actions: [drink, clear], intentIdentifiers: [], options: [])
        
        let center = UNUserNotificationCenter.current()
        center.setNotificationCategories([category])
        
    }
    
    func scheduleNotification (event : String, time: DateComponents, hourString:String) {
        print("SCHEDULENOTIFICATION CALLED")
        let content = UNMutableNotificationContent()
        
        content.title = event
        content.body = "Time to drink."
        content.categoryIdentifier = "CALLINNOTIFICATION"
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: time, repeats:true)
        let identifier = "id_"+event+hourString
        let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: { (error) in
        })
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("didReceive")
        switch response.actionIdentifier {
        case "drink":
            print("drink!")
        default:
            print("Ah!")
        }
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("willPresent")
        completionHandler([.badge, .alert, .sound])
    }
    
    func updateIconLabel () {
        upperLabel.text = String(userProfile.waterDrank) + "ml"
        lowerLabel.text = String(userProfile.waterTarget) + "ml"
        if tapMeTrue == false {
            tapMeLabel.isHidden = false
            upperLabel.isHidden = true
            lowerLabel.isHidden = true
            lineImage.isHidden = true
        } else {
            tapMeLabel.isHidden = true
            upperLabel.isHidden = false
            lowerLabel.isHidden = false
            lineImage.isHidden = false
        }
    }
}



