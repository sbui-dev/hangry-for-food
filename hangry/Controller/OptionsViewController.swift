//
//  OptionsViewController.swift
//  hangry
//
//  Created by Steven Bui on 4/1/19.
//  Copyright © 2019 Steven Bui. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {
    
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var radiusText: UITextField!
    @IBOutlet weak var openSwitch: UISwitch!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is GimmeFoodViewController {

            let vc = segue.destination as? GimmeFoodViewController
            
            if searchText.hasText {
                vc?.searchOptions.term = searchText.text!
            }
            
            if radiusText.hasText {
                vc?.searchOptions.radius = radiusText.text!
            }
            
            vc?.searchOptions.setOpen(open : openSwitch.isOn)
        }
    }

}
