//
//  UIApplication+Extension.swift
//  WeatherDataApp
//
//  Created by Rusiru Fernando on 5/20/22.
//

import UIKit

// used to hide the keyboard
extension UIApplication {
    
    // stope whatever that is using the keyboard to stop using it
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

