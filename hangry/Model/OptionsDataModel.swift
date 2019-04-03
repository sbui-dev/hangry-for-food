//
//  OptionsDataModel.swift
//  hangry
//
//  Created by Steven Bui on 4/1/19.
//  Copyright © 2019 Steven Bui. All rights reserved.
//

import Foundation

class SearchOptionsData {
    var term : String = "restaurant"
    var radius : String = "750"
    var open_now : String = "false" // TODO: change to true
    
    func setOpen(open : Bool) {
        if open {
            open_now = "true"
        }
        else {
            open_now = "false"
        }
    }
}
