//
//  AlertExtension.swift
//  Vriends
//
//  Created by Tanner Luke on 9/21/18.
//  Copyright © 2018 Tanner Luke. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    
    func createAlert(with title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func createAlertPopVC(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
    }
    
    
    
    
    
    
}
