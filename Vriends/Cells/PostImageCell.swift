//
//  PostImageCell.swift
//  Vriends
//
//  Created by Tanner Luke on 10/15/18.
//  Copyright © 2018 Tanner Luke. All rights reserved.
//

import UIKit

class PostImageCell: UITableViewCell {
    
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var username: UIButton!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profilePic.translatesAutoresizingMaskIntoConstraints = false
        username.translatesAutoresizingMaskIntoConstraints = false
        caption.translatesAutoresizingMaskIntoConstraints = false
        likeCount.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        commentButton.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        picture.translatesAutoresizingMaskIntoConstraints = false
        
        setupViews()
        
    }
    
    func setupViews() {
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[profilePic(70)]", options: [], metrics: nil, views: ["profilePic":profilePic]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[username(25)]-10-[caption]-10-[picture(160)]-10-[likeLabel(20)]-10-[likeButton(40)]-5-|", options: [], metrics: nil, views: ["username":username, "caption":caption, "likeLabel":likeCount, "likeButton":likeButton, "picture":picture]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[username(25)]-10-[caption]-10-[picture(160)]-10-[likeLabel(20)]-10-[commentButton(40)]-5-|", options: [], metrics: nil, views: ["username":username, "caption":caption, "likeLabel":likeCount, "commentButton":commentButton, "picture":picture]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[timeLabel]", options: [], metrics: nil, views: ["timeLabel":timeLabel]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[profilePic(70)]-10-[username]-[timeLabel(50)]-10-|", options: [], metrics: nil, views: ["profilePic":profilePic, "timeLabel":timeLabel, "username":username]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[profilePic(70)]-10-[caption]-10-|", options: [], metrics: nil, views: ["profilePic":profilePic, "caption":caption]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[profilePic(70)]-10-[picture]-10-|", options: [], metrics: nil, views: ["profilePic":profilePic, "picture":picture]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-95-[likeCount]-10-|", options: [], metrics: nil, views: ["likeCount":likeCount]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[likeButton(==commentButton)]-0-[commentButton]-0-|", options: [], metrics: nil, views: ["likeButton":likeButton, "commentButton":commentButton]))
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
