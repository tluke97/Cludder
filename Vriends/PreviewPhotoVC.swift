//
//  PreviewPhotoVC.swift
//  Vriends
//
//  Created by Tanner Luke on 11/5/18.
//  Copyright © 2018 Tanner Luke. All rights reserved.
//

import UIKit

protocol ModalDelegate {
    func changeValue(value: UIImage)
}

class PreviewPhotoVC: UIViewController {
    
    

    var image: UIImage?
    var imageView: UIImageView?
    var closeButton: UIButton?
    var postButton = UIButton()
    
    var delegate: ModalDelegate!
    
    
    var passedPhotoArray = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        alignment()
        print(passedPhotoArray)
        
        
    }
    
    
    func alignment() {
        imageView = UIImageView()
        imageView?.backgroundColor = .blue
        imageView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        imageView?.image = image
        self.view.addSubview(imageView!)
        
        closeButton = UIButton()
        closeButton?.frame = CGRect(x: 15, y: 15, width: 50, height: 50)
        closeButton?.setTitle("Back", for: .normal)
        closeButton?.addTarget(self, action: #selector(close), for: .touchUpInside)
        self.view.addSubview(closeButton!)
        
        postButton.frame = CGRect(x: self.view.frame.size.width - 65, y: 15, width: 50, height: 30)
        postButton.setTitle("Post", for: .normal)
        postButton.addTarget(self, action: #selector(postPicture), for: .touchUpInside)
        self.view.addSubview(postButton)
    }

    @objc func close() {
        //self.navigationController?.popViewController(animated: false)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func postPicture() {
        passedPhotoArray.append(image!)
        print(passedPhotoArray)
        //let parentVc = self.navigationController?.parent as! NewPostVC
        //parentVc.imageArray = passedPhotoArray
        //self.dismiss(animated: true, completion: nil)
        let navVc = self.presentingViewController?.presentingViewController as! UINavigationController
        let postVc = navVc.topViewController as! NewPostVC
        postVc.imageArray = passedPhotoArray
        presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        
        
        //presentingViewController?.dismiss(animated: true, completion: nil)
        //self.performSegue(withIdentifier: "toPost", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPost" {
            let navVC = segue.destination as! UINavigationController
            let postVC = navVC.topViewController as! NewPostVC
            postVC.imageArray = passedPhotoArray
            
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
