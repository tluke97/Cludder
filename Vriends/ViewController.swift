//
//  ViewController.swift
//  Vriends
//
//  Created by Tanner Luke on 9/9/18.
//  Copyright © 2018 Tanner Luke. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var newUserButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var resetPasswordButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        alignment()
        print(UserDefaults.standard.string(forKey: "uid"))
    }
    
    func alignment() {
        logoLabel.frame = CGRect(x: 0, y: self.view.frame.size.height/5 - 50, width: self.view.frame.size.width, height: 50)
        logoLabel.textAlignment = .center
        newUserButton.frame = CGRect(x: 0, y: self.view.frame.size.height / 2, width: self.view.frame.size.width/2, height: self.view.frame.size.height - (self.view.frame.size.height/2) - 80)
        loginButton.frame = CGRect(x: self.view.frame.size.width/2, y: self.view.frame.size.height / 2, width: self.view.frame.size.width/2, height: self.view.frame.size.height - (self.view.frame.size.height/2) - 80)
        let line = UIView()
        line.frame = CGRect(x: 0, y: self.view.frame.size.height / 2, width: self.view.frame.size.width, height: 2.5)
        line.backgroundColor = .white
        self.view.addSubview(line)
        resetPasswordButton.frame = CGRect(x: 0, y: self.view.frame.size.height - 80, width: self.view.frame.size.width, height: 80)
        emailText.frame = CGRect(x: 20, y: (((self.logoLabel.frame.origin.y + 50) + (self.loginButton.frame.origin.y))/2) - 40, width: self.view.frame.size.width - 40, height: 30)
        passwordText.frame = CGRect(x: 20, y: self.emailText.frame.origin.y + 50, width: self.view.frame.size.width - 40, height: 30)
    }

    
    
    
    
    //ACTIONS
    @IBAction func newUserButtonClick(_ sender: Any) {
        self.performSegue(withIdentifier: "createProfile", sender: self)
    }
    
    @IBAction func loginButtonClick(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (result, error) in
            if error == nil {
                print("logged in")
                UserDefaults.standard.setValue(Auth.auth().currentUser!.uid, forKey: "uid")
                
                let db = Firestore.firestore()
                let _ = db.collection("Users").document(Auth.auth().currentUser!.uid)
                
                
                
                
                self.performSegue(withIdentifier: "loggedIn", sender: self)
            } else {
                print(error!.localizedDescription)
                self.createAlert(with: "There was an error signing in", message: error!.localizedDescription)
            }
        }
    }
    
    @IBAction func resetPasswordButtonClick(_ sender: Any) {
        
    }
    
}

