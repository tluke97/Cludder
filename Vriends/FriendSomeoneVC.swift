//
//  FriendSomeoneVC.swift
//  Vriends
//
//  Created by Tanner Luke on 9/17/18.
//  Copyright © 2018 Tanner Luke. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

class FriendSomeoneVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var cameraView: UIView!
    
    
    var currentUser: String?
    var foundUid: String?
    
    
    
    var db = Firestore.firestore()
    var captureSession: AVCaptureSession!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var qrCodeFrameView = UIImageView()
    var friendView = UIView()
    var exitView = UIView()
    let nameLabel = UILabel()
    let profileImage = UIImageView()
    let acceptFriend = UIButton()
    let friendNotActiveLabel = UILabel()
    let additionalInfoLabel = UILabel()
    let dismissButton = UIButton()
    
    
    var friendIsActive: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        setupCamera()
        
        let exitButton = UIButton()
        exitButton.frame = CGRect(x: 15, y: 35, width: 30, height: 30)
        exitButton.addTarget(self, action: #selector(closeOut), for: .touchUpInside)
        exitButton.backgroundColor = .cyan
        exitButton.setTitle("X", for: .normal)
        self.view.addSubview(exitButton)
        
        
        qrCodeFrameView.frame = CGRect(x: self.view.frame.size.width/2 - 87.5, y: self.view.frame.size.height/2 - 87.5, width: 175, height: 175)
        qrCodeFrameView.image = UIImage(named: "FrameBorder.png")
        qrCodeFrameView.contentMode = .scaleAspectFit
        self.view.addSubview(qrCodeFrameView)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    
    func setupCamera() {
        captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {return}
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            print(error)
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            print("there was an error")
            return
        }
        
        let metaDataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metaDataOutput) {
            captureSession.addOutput(metaDataOutput)
            
            metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metaDataOutput.metadataObjectTypes = [.qr]
        } else {
            print("there was an error 2")
            return
        }
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.frame = view.layer.bounds
        videoPreviewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(videoPreviewLayer)
        
        captureSession.startRunning()
        
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
       // captureSession.stopRunning()
       
        
        if let metadataObject = metadataObjects.first {
            
            
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            print(stringValue)
            
            let label = UILabel()
            label.frame = CGRect(x: 40, y: 100, width: 200, height: 30)
            label.text = stringValue
            self.view.addSubview(label)
            
            var newString = stringValue
            
            
            
            foundFriend(friendUid: newString)
            foundUid = newString
            captureSession.stopRunning()
            
            
        }
    }
    
    func foundFriend(friendUid: String) {
        
        exitView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.addSubview(exitView)
        
        
        friendView.frame = CGRect(x: 20, y: self.view.frame.size.height, width: self.view.frame.size.width, height: 400)
        friendView.backgroundColor = .gray
        friendView.layer.cornerRadius = 40
        self.view.addSubview(friendView)
        
        profileImage.frame = CGRect(x: self.friendView.frame.size.width/2 - 95, y: 40, width: 150, height: 150)
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
        self.friendView.addSubview(profileImage)
        
        
        nameLabel.frame = CGRect(x: -20, y: 220, width: self.friendView.frame.size.width, height: 30)
        nameLabel.font = UIFont(name: "Helvetica Neue", size: 25)
        nameLabel.textAlignment = .center
        nameLabel.text = ""
        self.friendView.addSubview(nameLabel)
        
        friendNotActiveLabel.frame = CGRect(x: 0, y: 25, width: self.friendView.frame.size.width - 40, height: 100)
        friendNotActiveLabel.numberOfLines = 0
        friendNotActiveLabel.textAlignment = .center
        friendNotActiveLabel.font = UIFont(name: "Helvetica Neue", size: 23)
        friendNotActiveLabel.textColor = .white
        friendView.addSubview(friendNotActiveLabel)
        friendNotActiveLabel.isHidden = true
        
        additionalInfoLabel.frame = CGRect(x: 20, y: friendNotActiveLabel.frame.origin.y + friendNotActiveLabel.frame.size.height, width: self.friendView.frame.size.width - 80, height: 100)
        additionalInfoLabel.numberOfLines = 0
        additionalInfoLabel.textAlignment = .center
        additionalInfoLabel.font = UIFont(name: "Helvetica Neue", size: 16)
        additionalInfoLabel.textColor = .white
        friendView.addSubview(additionalInfoLabel)
        additionalInfoLabel.text = "Make sure that both phones are in the same area and both users have the app running! Rescan QR code to add friend."
        additionalInfoLabel.isHidden = true
        
        
        dismissButton.frame = CGRect(x: self.friendView.frame.size.width/2 - 110, y: self.nameLabel.frame.origin.y + 70, width: 180, height: 55)
        dismissButton.backgroundColor = .cyan
        dismissButton.setTitle("Okay", for: .normal)
        dismissButton.layer.cornerRadius = 27.5
        dismissButton.addTarget(self, action: #selector(hideFriendView), for: .touchUpInside)
        friendView.addSubview(dismissButton)
        dismissButton.isHidden = true
        
        
        acceptFriend.frame = CGRect(x: self.friendView.frame.size.width/2 - 110, y: self.nameLabel.frame.origin.y + 70, width: 180, height: 55)
        acceptFriend.backgroundColor = .cyan
        acceptFriend.setTitle("Add Friend", for: .normal)
        acceptFriend.layer.cornerRadius = 27.5
        acceptFriend.addTarget(self, action: #selector(addFriendClick), for: .touchUpInside)
        friendView.addSubview(acceptFriend)
        
        
        
        db.collection("Users").document(friendUid).getDocument { (document, error) in
            if let document = document, document.exists {
                let userData = document.data()
                self.nameLabel.text = (userData!["fullname"] as! String)
                self.profileImage.getProfilePic(path: userData!["profilePicPath"] as! String)
                self.friendIsActive = userData!["addable"] as! Bool
               
            }
        }
        
        UIView.animate(withDuration: 0.45) {
            self.friendView.frame = CGRect(x: 20, y: UIScreen.main.bounds.height / 2 - 250, width: self.view.frame.size.width - 40, height: 400)
            
        }
        
        let closeOutTap = UITapGestureRecognizer(target: self, action: #selector(hideFriendView))
        closeOutTap.numberOfTapsRequired = 1
        exitView.addGestureRecognizer(closeOutTap)
        
    }
    
    
    @objc func addFriendClick() {
       
        if friendIsActive == true {
            
            let ref = db.collection("Users").document((Auth.auth().currentUser?.uid)!)
            ref.updateData([
                
                "friends" : FieldValue.arrayUnion([currentUser!])
                
            ]) { (error) in
                if error == nil {
                    self.acceptFriend.setTitle("Friends", for: .normal)
                    
                    let friendProfile = self.storyboard?.instantiateViewController(withIdentifier: "FriendProfileVC") as! FriendProfileVC
                    friendProfile.passedFriendUid = self.foundUid!
                    self.navigationController?.pushViewController(friendProfile, animated: true)
                }
            }
            
            /*
            let ref = db.collection("Users").addDocument(data: [
                
                "friends" :
                
                "friendName" : currentUser!,
                "friendName2" : self.nameLabel.text!,
                "uid" : Auth.auth().currentUser!.uid,
                "uid2" : foundUid!
                
            ]) { (error) in
                if error == nil {
                    self.acceptFriend.setTitle("Friends", for: .normal)
                    
                    let friendProfile = self.storyboard?.instantiateViewController(withIdentifier: "FriendProfileVC") as! FriendProfileVC
                    friendProfile.passedFriendUid = self.foundUid!
                    self.navigationController?.pushViewController(friendProfile, animated: true)
                    
                }
            }
            */
        } else {
            
            profileImage.isHidden = true
            nameLabel.isHidden = true
            acceptFriend.isHidden = true
            friendNotActiveLabel.text = "\(self.nameLabel.text ?? "The user you are trying to add") is not currently adding friends."
            additionalInfoLabel.isHidden = false
            dismissButton.isHidden = false
            friendNotActiveLabel.isHidden = false
            
        }
        
      
    }
    
    
    
    
    @objc func hideFriendView() {
        
       
        
        
        
        UIView.animate(withDuration: 0.45, animations: {
            self.friendView.frame = CGRect(x: 20, y: self.view.frame.size.height, width: self.view.frame.size.width, height: 400)
        }) { (done) in
            if done == true {
                self.profileImage.isHidden = false
                self.nameLabel.isHidden = false
                self.acceptFriend.isHidden = false
                self.friendNotActiveLabel.isHidden = true
                self.additionalInfoLabel.isHidden = true
                self.dismissButton.isHidden = true
            }
        }
        
        
        
        
        exitView.removeFromSuperview()
        captureSession.startRunning()
       
    }
    
    
    @objc func closeOut() {
        self.navigationController?.popViewController(animated: true)
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
