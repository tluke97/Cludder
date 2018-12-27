//
//  FeedVC.swift
//  Vriends
//
//  Created by Tanner Luke on 10/14/18.
//  Copyright © 2018 Tanner Luke. All rights reserved.
//

import UIKit
import Firebase

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    let db = Firestore.firestore()
    var uuidArray = [String]()
    var hasMedia = [Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPosts()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uuidArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if hasMedia[indexPath.row] == true {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MediaCell", for: indexPath) as! PostImageCell
            
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! PostTextCell
            
            return cell
        }
    }
    
    func getPosts() {
        print("RINNING")
        db.collection("Posts").whereField("BelongsTo", isEqualTo: "WC3yTbFGitbfZ8urJi7pBqezwug2").limit(to: 20).getDocuments { (snapshot, error) in
            if let err = error {
                print(err)
                print("ERROR")
            } else {
                for document in snapshot!.documents {
                    print("success")
                    print(document.data())
                }
            }
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
