//
//  OTMTextFieldDelegate.swift
//  On The Map
//
//  Created by atao1 on 5/1/18.
//  Copyright © 2018 atao. All rights reserved.
//

import Foundation
import UIKit

class OTMTextFieldDelegate: NSObject, UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.text = ""
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
