//
//  PostImage3Cell.swift
//  TestForCludder
//
//  Created by Tanner Luke on 12/16/18.
//  Copyright © 2018 Tanner Luke. All rights reserved.
//

import UIKit

class PostImage3Cell: UITableViewCell {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var username: UIButton!
    
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var picture: UIImageView!
    
    @IBOutlet weak var picture2: UIImageView!
    @IBOutlet weak var picture3: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    
    
    var width: CGFloat!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        width = self.frame.size.width
        
        profilePic.translatesAutoresizingMaskIntoConstraints = false
        username.translatesAutoresizingMaskIntoConstraints = false
        caption.translatesAutoresizingMaskIntoConstraints = false
        likeCount.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        commentButton.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        picture.translatesAutoresizingMaskIntoConstraints = false
        picture2.translatesAutoresizingMaskIntoConstraints = false
        picture3.translatesAutoresizingMaskIntoConstraints = false
        
        setupViews()
        
    }
    
    func setupViews() {
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[profilePic(70)]", options: [], metrics: nil, views: ["profilePic":profilePic]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[username(25)]-10-[caption]-10-[picture(160)]-10-[likeLabel(20)]-10-[likeButton(40)]-5-|", options: [], metrics: nil, views: ["username":username, "caption":caption, "likeLabel":likeCount, "likeButton":likeButton, "picture":picture, "picture2":picture2]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[username(25)]-10-[caption]-10-[picture2(==picture3)]-3-[picture3]-10-[likeLabel(20)]-10-[commentButton(40)]-5-|", options: [], metrics: nil, views: ["username":username, "caption":caption, "likeLabel":likeCount, "commentButton":commentButton, "picture3":picture3, "picture2":picture2]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[timeLabel]", options: [], metrics: nil, views: ["timeLabel":timeLabel]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[profilePic(70)]-10-[username]-[timeLabel(50)]-10-|", options: [], metrics: nil, views: ["profilePic":profilePic, "timeLabel":timeLabel, "username":username]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[profilePic(70)]-10-[caption]-10-|", options: [], metrics: nil, views: ["profilePic":profilePic, "caption":caption]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[profilePic(70)]-10-[picture(==picture2)]-3-[picture2]-10-|", options: [], metrics: nil, views: ["profilePic":profilePic, "picture":picture, "picture2":picture2]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[profilePic(70)]-10-[picture(==picture3)]-3-[picture3]-10-|", options: [], metrics: nil, views: ["profilePic":profilePic, "picture":picture, "picture3":picture3]))//
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[profilePic(70)]-10-[picture2(==picture3)]-3-[picture3]-10-|", options: [], metrics: nil, views: ["profilePic":profilePic, "picture2":picture, "picture3":picture3]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-95-[likeCount]-10-|", options: [], metrics: nil, views: ["likeCount":likeCount]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[likeButton(==commentButton)]-0-[commentButton]-0-|", options: [], metrics: nil, views: ["likeButton":likeButton, "commentButton":commentButton]))
        
    }
    

}
