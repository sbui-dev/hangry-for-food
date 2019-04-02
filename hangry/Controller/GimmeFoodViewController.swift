//
//  GimmeFoodViewController.swift
//  hangry
//
//  Created by Steven Bui on 4/1/19.
//  Copyright © 2019 Steven Bui. All rights reserved.
//

import UIKit
import Foundation

class GimmeFoodViewController: UIViewController {
    
    @IBOutlet weak var gimmeFoodButton: UIButton!
    @IBOutlet weak var optionsButton: UIButton!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    /*@IBAction func showSettingsPopup(_ sender: Any) {
        let popupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "settingsPopup") as! SettingsViewController
        self.addChild(popupVC)
        popupVC.view.frame = self.view.frame
        self.view.addSubview(popupVC.view)
        popupVC.didMove(toParent: self)
    }*/
}
