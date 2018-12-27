//
//  ProfileVC.swift
//  Vriends
//
//  Created by Tanner Luke on 9/11/18.
//  Copyright © 2018 Tanner Luke. All rights reserved.
//

import UIKit
import Firebase

var userIsActive = false

class ProfileVC: UITableViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var friendsLabel: UILabel!
    @IBOutlet weak var friendsCountLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var postCountLabel: UILabel!
    @IBOutlet weak var bioText: UILabel!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    let uid: String = UserDefaults.standard.string(forKey: "uid")!
    
    let line = UIView()
    let db = Firestore.firestore()
    let slideView = UIView()
    let exitView = UIView()
    let goToCamera = UIButton()
    
    var friendNumber: Int?
    
    var justSignedUp: Bool = false

    
    weak var shapeLayer: CAShapeLayer?
    weak var shapeLayer1: CAShapeLayer?
    let blueColor = UIColor(displayP3Red: 75/255, green: 239/255, blue: 211/255, alpha: 1)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getProfileData()
        animate()
        drawBottomLine()
        
        print(justSignedUp)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let headerView = tableView.tableHeaderView else { return }
        let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        if headerView.frame.size.height != size.height {
            headerView.frame.size.height = size.height
            tableView.tableHeaderView = headerView
            tableView.layoutIfNeeded()
            self.line.removeFromSuperview()
            drawBottomLine()
        }
        
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
        super.prepare(for: segue, sender: self)
        if segue.identifier == "scanFriend" {
            let vc = segue.destination as! FriendSomeoneVC
            vc.currentUser = name.text
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    func signedUp() {
        if justSignedUp == true {
            
        }
    }
    
    func setup() {
        profilePic.translatesAutoresizingMaskIntoConstraints = false
        profilePic.layer.cornerRadius = profilePic.frame.size.height/2
        profilePic.clipsToBounds = true
    }
    
    func animate() {
        
        self.shapeLayer?.removeFromSuperlayer()
        
        // create whatever path you want
        
        let path = UIBezierPath()
        let path1 = UIBezierPath()
        
        path.move(to: CGPoint(x: 0, y: 60))
        path.addLine(to: CGPoint(x: 15, y: 60))
        path1.move(to: CGPoint(x: 0, y: 60))
        path1.addLine(to: CGPoint(x: 15, y: 60))
        //path.addLine(to: CGPoint(x: 200, y: 240))
        //path.addCurve(to: CGPoint(x: 102, y: 80), controlPoint1: CGPoint(x: 50, y: -100), controlPoint2: CGPoint(x: 100, y: 350))
        path.addArc(withCenter: profilePic.center, radius: 45, startAngle: CGFloat(Double.pi), endAngle: (CGFloat(Double.pi) * 2), clockwise: true)
        path1.addArc(withCenter: profilePic.center, radius: 45, startAngle: CGFloat(Double.pi), endAngle: CGFloat(
            Double.pi * 2), clockwise: false)
        
        path.addLine(to: CGPoint(x: UIScreen.main.bounds.width , y: 60))
        path1.addLine(to: CGPoint(x: UIScreen.main.bounds.width , y: 60))
        
        // create shape layer for that path
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        shapeLayer.strokeColor = blueColor.cgColor
        shapeLayer.lineWidth = 5
        shapeLayer.path = path.cgPath
        
        let shapeLayer1 = CAShapeLayer()
        shapeLayer1.fillColor = UIColor.clear.cgColor
        shapeLayer1.strokeColor = blueColor.cgColor
        shapeLayer1.lineWidth = 5
        shapeLayer1.path = path1.cgPath
        
        
        // animate it
        
        self.view.layer.addSublayer(shapeLayer)
        self.view.layer.addSublayer(shapeLayer1)
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.duration = 1.5
        shapeLayer.add(animation, forKey: "MyAnimation")
        shapeLayer1.add(animation, forKey: "MyAnimation")
        
        // save shape layer
        
        self.shapeLayer = shapeLayer
        self.shapeLayer1 = shapeLayer1
    }
    
    func drawBottomLine() {
       self.line.frame = CGRect(x: 0, y: self.headerView.frame.size.height - 1, width: self.view.frame.size.width, height: 1)
        self.line.backgroundColor = .gray
        self.headerView.addSubview(self.line)
    }
    
    func getProfileData() {
        let ref = db.collection("Users").document(uid)
        
        
        
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                print("this is the document", document)
                //let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                
                self.name.text = document.data()?["fullname"] as? String
                self.bioText.text = document.data()?["bio"] as? String
                self.profilePic.getProfilePic(path: (document.data()?["profilePicPath"] as? String)!)
                if let friendCountNum = document.data()?["friendCount"] as? Int {
                    self.friendsCountLabel.text = String(friendCountNum)
                }
                if let postCountNum = document.data()?["postCount"] as? Int {
                    self.postCountLabel.text = String(postCountNum)
                }
                
                
                
            }
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
        nameLabel.text = name.text
        nameLabel.textAlignment = .center
        slideView.addSubview(nameLabel)
        
        goToCamera.frame = CGRect(x: slideView.frame.size.width/2 - 60, y: 40, width: 80, height: 45)
        goToCamera.setBackgroundImage(UIImage(named: "CameraAdd.png"), for: .normal)
        goToCamera.addTarget(self, action: #selector(scanFriend), for: .touchUpInside)
        slideView.addSubview(goToCamera)
        
        //qrCode.backgroundColor = .blue
        UIView.animate(withDuration: 0.45) {
            self.slideView.frame = CGRect(x: 20, y: UIScreen.main.bounds.height / 2 - 250, width: self.view.frame.size.width - 40, height: 400)
           
        }
        
        self.tableView.isScrollEnabled = false
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
        self.performSegue(withIdentifier: "scanFriend", sender: self)
    }
    

    @IBAction func settingsButtonClick(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            UserDefaults.standard.removeObject(forKey: "uid")
            self.navigationController?.navigationBar.isHidden = true
            self.performSegue(withIdentifier: "logout", sender: self)
            
        } catch let signOutError as NSError {
            print("There was an error signing out:", signOutError)
        }
        
    }
    

    @IBAction func click(_ sender: Any) {
        slideOutView()
    }
    
    
}
