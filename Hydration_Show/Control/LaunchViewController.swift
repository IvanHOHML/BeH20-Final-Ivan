//
//  LaunchViewController.swift
//  Hydration_Show
//
//  Created by Jason So on 5/9/2020.
//  Copyright © 2020  Ho Ivan. All rights reserved.
//

import Foundation
import UIKit

class LaunchViewController : UIViewController {
    
    let timer = Timer()
    
    @IBOutlet weak var launchImage: UIImageView!
    
    let imageStrArray = ["revised_","revised_b","revised_be","revised_beH","revised_beH2","revised_beH2O"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for n in 0...5 {
            Timer.scheduledTimer(withTimeInterval: 0.1 * (Double(n) * 1.5), repeats: false) {_ in
                self.launchImage.image = UIImage(contentsOfFile: self.imageStrArray[n])
            }
        }
    }
    
}
