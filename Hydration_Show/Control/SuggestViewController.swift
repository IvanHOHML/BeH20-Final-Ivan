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
        
    }

    @IBAction func customButtonPressed(_ sender: UIButton) {
        
        var textField = UITextField()

        let alert = UIAlertController(title: "Customise Daily Water Input", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Confirm", style: .default) { (action) in

//NEED TO RESTRICT INPUT TO NUMBERS
            let range = 500...10000
            if  range.contains((Int(textField.text!) ?? 0)) {
            self.litreVal = (textField.text!)
            self.litreLabel.text = self.litreVal + " ml"
//   self.defaults.set(self.itemArray, forKey: "TodoListArray")

            } else {
                print("NO!")
            }
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Please insert an amount in Litre"
            textField = alertTextField
        }

        alert.addAction(action)
        func textFieldDidBeginEditing(_ textField: UITextField) {
            action.isEnabled = false
        }
        
        present(alert, animated: true, completion: nil)
        //userProfile.waterTarget = textField.text
        //updateData(userProfile)
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
    
    // JASON - FUNCTION FOR UPDATING LOCAL DATA
    func updateData(_ profile: UserProfile) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(profile) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "UserProfile")
        }
    }
    
}
