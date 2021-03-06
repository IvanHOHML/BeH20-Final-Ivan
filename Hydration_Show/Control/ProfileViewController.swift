//
//  ViewController.swift
//  Hydration Profile
//
//  Created by Jason So on 1/9/2020.
//  Copyright © 2020 Jason So. All rights reserved.
//
import UIKit

class ProfileViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var activityLevelZero: UIButton!
    @IBOutlet weak var activityLevelOne: UIButton!
    @IBOutlet weak var activityLevelTwo: UIButton!
    @IBOutlet weak var activityLevelThree: UIButton!
    @IBOutlet weak var genderImage: UIImageView!
    @IBOutlet weak var exerciseImage: UIImageView!
    @IBOutlet weak var btnNext: UIButton!
    
    var gender : String = ""
    var age : Int = 0
    var height : Double = 0.0
    var weight : Double = 0.0
    var activity : String = ""
    var userProfile = UserProfile(gender: "", age: 0, height: 0.0, weight: 0.0, activity: "")
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ageTextField.delegate = self
        heightTextField.delegate = self
        weightTextField.delegate = self
        showUserDefaultValue()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(red: CGFloat(46)/255.0, green: CGFloat(196)/255.0,blue: CGFloat(182)/255.0, alpha: 1.0)
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)

    }

    @IBAction func genderChanged(_ sender: UIButton) {
        if sender.currentTitle == "Male" {
            genderImage.image = UIImage(named: "GenderDark_Male")
        } else {
            genderImage.image = UIImage(named: "GenderDark_Female")
        }
        gender = sender.currentTitle!
        print(gender)
    }
    
    
    @IBAction func activityLevelChanged(_ sender: UIButton) {
        
        switch sender.currentTitle {
            case "0" :
                exerciseImage.image = UIImage(named: "ExerciseDark_0")
            case "1" :
                exerciseImage.image = UIImage(named: "ExerciseDark_1")
            case "2" :
                exerciseImage.image = UIImage(named: "ExerciseDark_2")
            case "3" :
                exerciseImage.image = UIImage(named: "ExerciseDark_3")
            default:
                exerciseImage.image = UIImage(named: "ExerciseDark_Default")
        }
        
        activity = sender.currentTitle!
        
    }
    
    @IBAction func textFieldTouchDown(_ sender: UITextField) {
        if sender.text == ". . ." || sender.text == "0.0" || sender.text == "0"  {
            sender.text = ""
        } else {
            sender.textColor = UIColor(red: CGFloat(255)/255.0, green: CGFloat(255)/255.0,blue: CGFloat(255)/255.0, alpha: 1.0)
        }
    }
    
    @IBAction func textFieldEditEnd(_ sender: UITextField) {
        sender.textColor = UIColor(red: CGFloat(255)/255.0, green: CGFloat(255)/255.0,blue: CGFloat(255)/255.0, alpha: 1.0)
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        if let height = Double(heightTextField.text!),
            let weight = Double(weightTextField.text!),
            let age = Int(ageTextField.text!) {
            
            userProfile = UserProfile(gender: gender, age: age, height: height, weight: weight, activity: activity)
            userProfile.setWaterTarget(userSet: false, userSetValue: 0)
            
            updateData(userProfile)
            
            self.performSegue(withIdentifier: "toSuggest", sender: self)
        }
        else {
            let alert = UIAlertController(title: "Please input a Valid Value", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Confirm", style: .default) { (action) in
                
            }
            if alert.actions == [] {
                alert.addAction(action)
            }
            present(alert, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSuggest" {
            let destinationVC = segue.destination as! SuggestViewController
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
    
    func showUserDefaultValue() {
        
        age = userProfile.age
        gender = userProfile.gender
        height = userProfile.height
        weight = userProfile.weight
        activity = userProfile.activity
        
        if userProfile.gender != "" {
            //Set Default Value
            if userProfile.gender == "Female" {
                genderImage.image = UIImage(named: "GenderDark_Male")
            } else {
                genderImage.image = UIImage(named: "GenderDark_Female")
            }
        }
        ageTextField.text = String(userProfile.age)
        heightTextField.text = String(userProfile.height)
        weightTextField.text = String(userProfile.weight)
        
        switch userProfile.activity {
            case "0" :
                exerciseImage.image = UIImage(named: "ExerciseDark_0")
            case "1" :
                exerciseImage.image = UIImage(named: "ExerciseDark_1")
            case "2" :
                exerciseImage.image = UIImage(named: "ExerciseDark_2")
            case "3" :
                exerciseImage.image = UIImage(named: "ExerciseDark_3")
            default:
                exerciseImage.image = UIImage(named: "ExerciseDark_Default")
        }
    }
 
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("true!")

    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      return (string.containsValidCharacter)
    }

    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
}

extension String {

var containsValidCharacter: Bool {
    guard self != "" else { return true }
    let numSet = CharacterSet(charactersIn: "1234567890.")
    let newSet = CharacterSet(charactersIn: self)
    return numSet.isSuperset(of: newSet)
  }

}
