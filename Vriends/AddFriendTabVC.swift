//
//  AddFriendTabVC.swift
//  Vriends
//
//  Created by Tanner Luke on 9/22/18.
//  Copyright © 2018 Tanner Luke. All rights reserved.
//

import UIKit
import Firebase

class AddFriendTabVC: UIViewController {

    @IBOutlet weak var scanQRCodeButton: UIButton!
    @IBOutlet weak var createQRCodeButton: UIButton!
    
    let line = UIView()
    let db = Firestore.firestore()
    let slideView = UIView()
    let exitView = UIView()
    let goToCamera = UIButton()
    
    var name: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name = Auth.auth().currentUser?.displayName
        createQRCodeButton.layer.cornerRadius = createQRCodeButton.frame.size.height/2
        scanQRCodeButton.layer.cornerRadius = scanQRCodeButton.frame.size.height/2
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if userIsActive == true {
            let ref = db.collection("Users").document(Auth.auth().currentUser!.uid)
            ref.updateData([
                
                "addable" : false
                
            ]) { (error) in
                if error == nil {
                    userIsActive = false
                    print("updated")
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toScanner" {
            self.navigationController?.navigationBar.isHidden = true
            self.tabBarController?.tabBar.isHidden = true
            
        }
    }
    
    
    
    @objc func slideOutView() {
        
        exitView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.addSubview(exitView)
        
        slideView.frame = CGRect(x: 20, y: self.view.frame.size.height, width: self.view.frame.size.width, height: 400)
        slideView.backgroundColor = UIColor(displayP3Red: 75/255, green: 239/255, blue: 211/255, alpha: 1)
        //UIColor(red: 46/255, green: 68/255, blue: 95/255, alpha: 1)
        slideView.layer.cornerRadius = 40
        view.addSubview(slideView)
        
        let ref = db.collection("Users").document(Auth.auth().currentUser!.uid)
        ref.updateData([
            "addable" : true
            
        ]) { (error) in
            if error == nil {
                let frame = CGRect(x: self.slideView.frame.size.width/2 - 125, y: self.slideView.frame.size.height - 300, width: 250, height: 250)
                let qrCode = QRCodeView(frame: frame)
                qrCode.layer.cornerRadius = 30
                qrCode.generateCode(input: Auth.auth().currentUser!.uid, foregroundColor: UIColor(displayP3Red: 75/255, green: 239/255, blue: 211/255, alpha: 1), backgroundColor: .white)
                self.slideView.addSubview(qrCode)
                userIsActive = true
            }
        }
        
        //iew.addSubview(qrCode)
        
        let nameLabel = UILabel(frame: CGRect(x: -20, y: 15, width: self.slideView.frame.size.width, height: 21))
        nameLabel.textColor = .white
        nameLabel.text = name
        nameLabel.textAlignment = .center
        slideView.addSubview(nameLabel)
        
        goToCamera.frame = CGRect(x: slideView.frame.size.width/2 - 60, y: 40, width: 80, height: 45)
        goToCamera.setBackgroundImage(UIImage(named: "CameraAdd.png"), for: .normal)
        goToCamera.addTarget(self, action: #selector(scanFriend), for: .touchUpInside)
        slideView.addSubview(goToCamera)
        
        //qrCode.backgroundColor = .blue
        UIView.animate(withDuration: 0.45) {
            self.slideView.frame = CGRect(x: 20, y: UIScreen.main.bounds.height / 2 - 200, width: self.view.frame.size.width - 40, height: 400)
            
        }
        
        
        let exitTap = UITapGestureRecognizer(target: self, action: #selector(slideBackView))
        exitTap.numberOfTapsRequired = 1
        exitView.addGestureRecognizer(exitTap)
        
    }
    
    @objc func slideBackView() {
        UIView.animate(withDuration: 0.45) {
            self.slideView.frame = CGRect(x: 20, y: self.view.frame.size.height, width: self.view.frame.size.width, height: 400)
        }
        exitView.removeFromSuperview()
        let ref = db.collection("Users").document(Auth.auth().currentUser!.uid)
        ref.updateData([
            
            "addable" : false
            
        ]) { (error) in
            if error == nil {
                userIsActive = false
                print("updated")
            }
        }
        
    }
    
    @objc func scanFriend() {
        self.performSegue(withIdentifier: "toScanner", sender: self)
    }
    
    
    @IBAction func scanQRCodeClick(_ sender: Any) {
        
        self.performSegue(withIdentifier: "toScanner", sender: self)
        
    }
    
    @IBAction func createQRCodeClick(_ sender: Any) {
        slideOutView()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
