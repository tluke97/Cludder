//
//  FriendProfileVC.swift
//  Vriends
//
//  Created by Tanner Luke on 9/21/18.
//  Copyright © 2018 Tanner Luke. All rights reserved.
//

import UIKit
import Firebase

class FriendProfileVC: UITableViewController {

    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var friendsLabel: UILabel!
    @IBOutlet weak var friendsCountLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var postCountLabel: UILabel!
    @IBOutlet weak var bioText: UILabel!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    var passedFriendUid: String?
    
    let line = UIView()
    let db = Firestore.firestore()
    
    weak var shapeLayer: CAShapeLayer?
    weak var shapeLayer1: CAShapeLayer?
    let blueColor = UIColor(displayP3Red: 75/255, green: 239/255, blue: 211/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setup()
        if let friendUid = passedFriendUid {
            getProfileData(uid: friendUid)
        } else {
            createAlert(with: "Error", message: "There was an error while retrieving profile data")
        }
        
        animate()
        drawBottomLine()
        
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
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
    
    
    func getProfileData(uid: String) {
        let ref = db.collection("Users").document(uid)
        
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                
                //let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                let arr = document.data()
                print("data desc: \(arr!["fullname"] ?? "")")
                self.name.text = document.data()?["fullname"] as? String
                self.bioText.text = document.data()?["bio"] as? String
                self.profilePic.getProfilePic(path: (document.data()?["profilePicPath"] as? String)!)
                
                
            }
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
