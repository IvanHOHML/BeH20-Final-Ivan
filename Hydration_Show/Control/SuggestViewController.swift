//
//  ViewController.swift
//  Waterproject
//
//  Created by Tigger on 1/9/2020.
//  Copyright © 2020 Tigger. All rights reserved.
//

import UIKit

class SuggestViewController: UIViewController, UITextFieldDelegate {
    
    var userProfile = UserProfile(gender: "", age: 0, height: 0.0, weight: 0.0, activity: "")
    var litreVal = ""
    
    //ini alert
    let alert = UIAlertController(title: "Customise Daily Water Input", message: "Please insert an amount between 500 and 10000 ml", preferredStyle: .alert)
    var ansWrong = false
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var litreLabel: UILabel!
    @IBOutlet weak var customButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var middleImageView: UIImageView!
    @IBOutlet weak var confirmBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: CGFloat(46)/255.0, green: CGFloat(196)/255.0,blue: CGFloat(182)/255.0, alpha: 1.0)
        //Retrievedata
        //WaterCalculator(weight,activity)
        litreLabel.text = "\(userProfile.waterTarget) ml"
        logoImageView.center = self.view.center
        self.view.addSubview(logoImageView)
        if let safeUserProfile = downloadData() {
            userProfile = safeUserProfile
        }
       
        
    }
    

    @IBAction func customButtonPressed(_ sender: UIButton) {
        
        var textField = UITextField()
    

        let action = UIAlertAction(title: "Confirm", style: .default) { (action) in
            
            //NEED TO RESTRICT INPUT TO NUMBERS
            let range = 500...10000
            if  range.contains((Int(textField.text!) ?? 0)) {
                self.litreVal = (textField.text!)
                self.litreLabel.text = self.litreVal + " ml"
                self.ansWrong = false
                self.userProfile.setWaterTarget(userSet: true, userSetValue: Int(textField.text!)!)
                self.updateData(self.userProfile)
                print(self.userProfile.waterTarget)
                //   self.defaults.set(self.itemArray, forKey: "TodoListArray")
                
            } else {
                self.present(self.alert, animated: true, completion: nil)
                self.ansWrong = true
            }
        }
        
        let action2 = UIAlertAction(title: "Cancel", style: .default) { (action) in

            }

        
        alert.addTextField{ (alertTextField) in
            alertTextField.delegate = self
            alertTextField.addTarget(self, action: #selector(self.textFieldDidBeginEditing), for: UIControl.Event.editingChanged)
            alertTextField.placeholder = "Type Here"
            textField = alertTextField
        }
        
        

        alert.addAction(action)
        alert.addAction(action2)
        present(alert, animated: true, completion: nil)
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let range = 500...10000
        if  range.contains((Int(textField.text!) ?? 0)) {
            textField.layer.borderColor = UIColor.gray.cgColor
            self.alert.actions[0].isEnabled = true
        } else {
            if self.ansWrong == true {
                textField.layer.borderColor = UIColor.red.cgColor
                textField.layer.borderWidth = 1.0
                self.alert.actions[0].isEnabled = false
            }
        }
    }

        //code to customise drinking water value
    
    @IBAction func showScreenButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toShow", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShow" {
            let destinationVC = segue.destination as! ShowViewController
            destinationVC.userProfile = userProfile
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
    
    // JASON - FUNCTION FOR UPDATING LOCAL DATA
    func updateData(_ profile: UserProfile) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(profile) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "UserProfile")
        }
    }
    
}
