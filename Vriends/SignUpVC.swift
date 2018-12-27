//
//  SignUpVC.swift
//  Vriends
//
//  Created by Tanner Luke on 9/9/18.
//  Copyright © 2018 Tanner Luke. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage


class SignUpVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var fullNameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var passwordCheckText: UITextField!
    @IBOutlet weak var bioText: UITextView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    //SETUP FIREBASE
    let db = Firestore.firestore()
    
    var scrollViewHeight: CGFloat = 0
    var keyboard = CGRect()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        alignment()
        scrollView.contentSize.height = self.view.frame.height
        scrollViewHeight = scrollView.frame.size.height
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpVC.hideKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: self)
        if segue.identifier == "signUpSuccessful" {
            let tab = segue.destination as! UITabBarController
            let nav = tab.viewControllers?.first as! UINavigationController
            let vc = nav.topViewController as! ProfileVC
            vc.justSignedUp = true
            
            
        }
    }
    
    func alignment() {
        
        profilePic.frame = CGRect(x: self.view.frame.size.width / 2 - (
            (self.view.frame.size.width/3)/2) , y: 50 , width: self.view.frame.size.width/3, height: self.view.frame.size.width/3)
        profilePic.layer.cornerRadius = self.profilePic.frame.width / 2
        profilePic.clipsToBounds = true
        profilePic.backgroundColor = .white
        fullNameText.frame = CGRect(x: 20, y: profilePic.frame.origin.y + self.view.frame.size.width/3 + 30, width: self.view.frame.size.width - 40, height: 30)
        emailText.frame = CGRect(x: 20, y: fullNameText.frame.origin.y + 50, width: self.view.frame.size.width - 40, height: 30)
        passwordText.frame = CGRect(x: 20, y: emailText.frame.origin.y + 50, width: self.view.frame.size.width - 40, height: 30)
        passwordCheckText.frame = CGRect(x: 20, y: passwordText.frame.origin.y + 50, width: self.view.frame.size.width - 40, height: 30)
        bioText.frame = CGRect(x: 20, y: passwordCheckText.frame.origin.y + 50, width: self.view.frame.size.width - 40, height: 80)
        cancelButton.frame = CGRect(x: 0, y: self.view.frame.size.height - 50, width: self.view.frame.size.width / 2, height: 50)
        submitButton.frame = CGRect(x: self.view.frame.size.width/2, y: self.view.frame.size.height - 50, width: self.view.frame.size.width/2, height: 50)
        let line = UIView()
        line.frame = CGRect(x: 0, y: self.view.frame.size.height - 50, width: self.view.frame.size.width, height: 2.5)
        line.backgroundColor = .white
        self.view.addSubview(line)
        let tapToHide = UITapGestureRecognizer(target: self, action: #selector(SignUpVC.hideKeyboardTap(recognizer:)))
        tapToHide.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tapToHide)
        
        let getProfilePic = UITapGestureRecognizer(target: self, action: #selector(SignUpVC.getProfilePic(recognizer:)))
        getProfilePic.numberOfTapsRequired = 1
        profilePic.isUserInteractionEnabled = true
        profilePic.addGestureRecognizer(getProfilePic)
        
    }
    
    private func registerUserWithUID(uid: String, profilePicPath: String) {
        db.collection("Users").document(Auth.auth().currentUser!.uid).setData(
            [
                "fullname" : fullNameText.text!,
                "birthday" : [0,0,0],
                "bio" : bioText.text!,
                "uid" : uid,
                "profilePicPath" : profilePicPath,
                "phoneNumber" : "",
                "addable" : false,
                "friends" : []

        ]) { (error) in
            if let error = error {
                print(error)
            } else {
                Auth.auth().signIn(withEmail: self.emailText.text!, password: self.passwordText.text!) { (result, error) in
                    if error == nil {
                        print("logged in")
                        
                        UserDefaults.standard.setValue(Auth.auth().currentUser!.uid, forKey: "uid")
                        self.performSegue(withIdentifier: "signUpSuccessful", sender: self)
                    } else {
                        print(error!.localizedDescription)
                        self.createAlert(with: "There was an error logging in", message: error!.localizedDescription)
                    }
                }
            }
        }
    }
    
    @objc func getProfilePic(recognizer: UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pic = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        profilePic.image = pic
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func showKeyboard(notification: NSNotification) {
        keyboard = ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue)!
        UIView.animate(withDuration: 0.4) {
            self.scrollView.frame.size.height = self.scrollViewHeight - self.keyboard.height
        }
    }
    
    @objc func hideKeyboard(notification: NSNotification) {
        UIView.animate(withDuration: 0.4) {
            self.scrollView.frame.size.height = self.view.frame.height
        }
    }
    
    @objc func hideKeyboardTap(recognizer: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    
    @IBAction func cancelButtonClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitButtonClick(_ sender: Any) {
        Auth.auth().createUser(withEmail: self.emailText.text!, password: self.passwordText.text!) { (result, error) in
            if error == nil {
                
                guard (result?.user) != nil else { return }
                
                let imageName = NSUUID().uuidString
                
                let storageRef = Storage.storage().reference().child("\(imageName).jpg")
                
                if let picData =
                    self.profilePic.image?.jpegData(compressionQuality: 0.5) {
                    storageRef.putData(picData, metadata: nil, completion: { (metadata, error) in
                    
                        guard let metadata = metadata else {
                            print(error!)
                            return
                        }
                        print(metadata)
                        
                        if let user = Auth.auth().currentUser {
                            let changeRequest = user.createProfileChangeRequest()
                            
                            changeRequest.displayName = self.fullNameText.text
                            changeRequest.commitChanges(completion: { (error) in
                                if error != nil {
                                    print(error!.localizedDescription)
                                }
                            })
                        }
                        
                        storageRef.downloadURL(completion: { (url, error) in
                            guard let downloadUrl = url else {
                                print(error!)
                                return
                            }
                            let uid = Auth.auth().currentUser?.uid
                            let urlString = downloadUrl.absoluteString
                            self.registerUserWithUID(uid: uid!, profilePicPath: urlString)
                            
                        })
                        
                     })
                }
                let id = Auth.auth().currentUser?.uid
                UserDefaults.standard.setValue(id, forKey: "uid")
                
            } else {
                print(error!)
            }
            
           // let ref = self.db.collection("Users").document(Auth.auth().currentUser!.uid)
           // ref.getDocument { (document, error) in
               //     if let document = document, document.exists {
            
            
           //     }
           // }
            
            
            
        }
        
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
