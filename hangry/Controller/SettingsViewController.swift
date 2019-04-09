//
//  SettingsViewController.swift
//  hangry
//
//  Created by Steven Bui on 4/1/19.
//  Copyright © 2019 Steven Bui. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func privacyPressed(_ sender: Any) {
        guard let url = URL(string : "http://sbui.net/hangry/privacy_policy.html") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func termsPressed(_ sender: Any) {
        guard let url = URL(string : "http://sbui.net/hangry/terms_and_conditions.html") else { return }
        UIApplication.shared.open(url)
        
    }
    
    @IBAction func softwarePressed(_ sender: Any) {
        guard let url = URL(string : "http://sbui.net/hangry/3rd_party_license.md") else { return }
        UIApplication.shared.open(url)
    }
}
