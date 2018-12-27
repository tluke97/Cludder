//
//  NewPostVC.swift
//  Vriends
//
//  Created by Tanner Luke on 10/16/18.
//  Copyright © 2018 Tanner Luke. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import AVFoundation
import AVKit
import Parse


class NewPostVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, ModalDelegate {
    
    func changeValue(value: UIImage) {
        self.imageArray.append(value)
    }
    

    @IBOutlet weak var textArea: UITextView!
    
    @IBOutlet weak var imageArea: UIImageView!
    @IBOutlet weak var imageArea2: UIImageView!
    @IBOutlet weak var imageArea3: UIImageView!
    @IBOutlet weak var imageArea4: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var videoView: UIView!
    

    
    @IBOutlet weak var pictureButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var videoCameraButton: UIButton!
    
    var storedY: CGFloat = 0
    
    var bottomConstraint: NSLayoutConstraint?
    
    var imageHeightConstraint: NSLayoutConstraint?
    var imageWidthConstraint: NSLayoutConstraint?
    var scrollViewBottomAnchor: NSLayoutConstraint?
    
    var imageAreaLeadingConstraint: NSLayoutConstraint?
    var imageAreaTopConstraint: NSLayoutConstraint?
    var imageAreaBottomConstraint: NSLayoutConstraint?
    var imageAreaTrailingConstraint: NSLayoutConstraint?
    var imageAreaCenterXConstraint: NSLayoutConstraint?
    var imageAreaWidthConstraint: NSLayoutConstraint?
    var imageAreaHeightConstraint: NSLayoutConstraint?
    
    var imageArea2LeadingConstraint: NSLayoutConstraint?
    var imageArea2TopConstraint: NSLayoutConstraint?
    var imageArea2BottomConstraint: NSLayoutConstraint?
    var imageArea2TrailingConstraint: NSLayoutConstraint?
    var imageArea2CenterXConstraint: NSLayoutConstraint?
    var imageArea2WidthConstraint: NSLayoutConstraint?
    var imageArea2HeightConstraint: NSLayoutConstraint?
    
    var imageArea3LeadingConstraint: NSLayoutConstraint?
    var imageArea3TopConstraint: NSLayoutConstraint?
    var imageArea3BottomConstraint: NSLayoutConstraint?
    var imageArea3TrailingConstraint: NSLayoutConstraint?
    var imageArea3CenterXConstraint: NSLayoutConstraint?
    var imageArea3WidthConstraint: NSLayoutConstraint?
    var imageArea3HeightConstraint: NSLayoutConstraint?
    
    var imageArea4LeadingConstraint: NSLayoutConstraint?
    var imageArea4TopConstraint: NSLayoutConstraint?
    var imageArea4BottomConstraint: NSLayoutConstraint?
    var imageArea4TrailingConstraint: NSLayoutConstraint?
    var imageArea4CenterXConstraint: NSLayoutConstraint?
    var imageArea4WidthConstraint: NSLayoutConstraint?
    var imageArea4HeightConstraint: NSLayoutConstraint?

    var textAreaY: CGFloat = 0
    var textAreaHeight: CGFloat = 0
    var keyboard = CGRect()
    var view1 = UIView()
    var y: CGFloat?
    var imageArray = [UIImage]()
    var reloadViews = false
    
    var player: AVPlayer?
    var playerView: AVPlayerLayer?
    
    var videoURL: URL?
    
    var safeAreaBottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom
    
    let db = Firestore.firestore()
    
    struct AspectRatio {
        var screenHeight: CGFloat
        var screenWidth: CGFloat
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard(notification:)), name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard(notification:)), name: UIWindow.keyboardWillHideNotification, object: nil)
        self.textArea.becomeFirstResponder()
        alignment()
        
      
        
        scrollView.alwaysBounceVertical = true
        scrollView.isUserInteractionEnabled = true
        
        self.navigationController?.navigationBar.isHidden = false
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        reloadAllImageViews()
        if reloadViews {
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: self)
        if segue.identifier == "toCamera" {
            let vc = segue.destination as! PhotoCameraVC
            
            vc.passedPhotoArray = imageArray
        }
    }
    
    func alignment() {
        textArea.text = ""
        
        view1.addSubview(pictureButton)
        view1.addSubview(cameraButton)
        view1.addSubview(videoCameraButton)
        pictureButton.frame = CGRect(x: 15, y: 10, width: 45, height: 30)
        cameraButton.frame = CGRect(x: 95, y: 10, width: 45, height: 30)
        videoCameraButton.frame = CGRect(x: 180, y: 10, width: 45, height: 30)
        
        imageArea2.clipsToBounds = true
        imageArea3.clipsToBounds = true
        imageArea4.clipsToBounds = true
        imageArea2.layer.cornerRadius = 10
        imageArea3.layer.cornerRadius = 10
        imageArea4.layer.cornerRadius = 10
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        [
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor)

            ].forEach{$0.isActive = true}


        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        [
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalToConstant: self.view.frame.size.width)
            ].forEach{$0.isActive = true}
        
        textArea.translatesAutoresizingMaskIntoConstraints = false
        [
            textArea.topAnchor.constraint(equalTo: contentView.topAnchor),
            textArea.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            textArea.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
            textArea.heightAnchor.constraint(equalToConstant: 38)
            ].forEach{ $0.isActive = true }
        textArea.font = UIFont.preferredFont(forTextStyle: .headline)
        
        textArea.delegate = self
        textArea.isScrollEnabled = false
        
       
        //textArea.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40)
        imageArea.translatesAutoresizingMaskIntoConstraints = false
        imageArea.contentMode = .scaleAspectFit

        imageAreaTopConstraint = imageArea.topAnchor.constraint(equalTo: textArea.bottomAnchor, constant: 5)
        imageAreaTopConstraint?.isActive = true
        imageAreaBottomConstraint = imageArea.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        imageAreaBottomConstraint?.isActive = true
        
        imageAreaCenterXConstraint = imageArea.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        imageAreaCenterXConstraint?.isActive = true
     
        imageAreaWidthConstraint = imageArea.widthAnchor.constraint(equalToConstant: 0)
        imageAreaWidthConstraint?.isActive = true
        imageAreaHeightConstraint = imageArea.heightAnchor.constraint(equalToConstant: 0)
        imageAreaHeightConstraint?.isActive = true
        
        imageArea2.translatesAutoresizingMaskIntoConstraints = false
        imageArea2.contentMode = .scaleAspectFit
        imageArea2TopConstraint = imageArea2.topAnchor.constraint(equalTo: imageArea.bottomAnchor, constant: 5)
        imageArea2TopConstraint?.isActive = true
        imageArea2BottomConstraint = imageArea2.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        imageArea2CenterXConstraint = imageArea2.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        imageArea2CenterXConstraint?.isActive = true
        
        imageArea2HeightConstraint = imageArea2.heightAnchor.constraint(equalToConstant: 0)
        imageArea2HeightConstraint?.isActive = true
        imageArea2WidthConstraint = imageArea2.widthAnchor.constraint(equalToConstant: 0)
        imageArea2WidthConstraint?.isActive = true
        
        imageArea3.translatesAutoresizingMaskIntoConstraints = false
        imageArea3.contentMode = .scaleAspectFit
        imageArea3TopConstraint = imageArea3.topAnchor.constraint(equalTo: imageArea2.bottomAnchor, constant: 5)
        imageArea3TopConstraint?.isActive = true
        imageArea3BottomConstraint = imageArea3.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        imageArea3CenterXConstraint = imageArea3.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        imageArea3CenterXConstraint?.isActive = true
        
        imageArea3HeightConstraint = imageArea3.heightAnchor.constraint(equalToConstant: 0)
        imageArea3HeightConstraint?.isActive = true
        imageArea3WidthConstraint = imageArea3.widthAnchor.constraint(equalToConstant: 0)
        imageArea3WidthConstraint?.isActive = true
        
        
        imageArea4.translatesAutoresizingMaskIntoConstraints = false
        imageArea4.contentMode = .scaleAspectFit
        imageArea4TopConstraint = imageArea4.topAnchor.constraint(equalTo: imageArea3.bottomAnchor, constant: 5)
        imageArea4TopConstraint?.isActive = true
        imageArea4BottomConstraint = imageArea4.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        imageArea4CenterXConstraint = imageArea4.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        imageArea4CenterXConstraint?.isActive = true
        
        imageArea4HeightConstraint = imageArea4.heightAnchor.constraint(equalToConstant: 0)
        imageArea4HeightConstraint?.isActive = true
        imageArea4WidthConstraint = imageArea4.widthAnchor.constraint(equalToConstant: 0)
        imageArea4WidthConstraint?.isActive = true
       
        
        //buttonStack.frame = CGRect(x: 10, y: 5, width: self.view.frame.size.width - 20, height: 40)
        // buttonStack.frame = CGRect(x: 15, y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
        
        
        imageArea.layer.cornerRadius = 10
        imageArea.clipsToBounds = true
        
        videoView.layer.cornerRadius = 10
        videoView.clipsToBounds = true
        
    }
    
    @IBAction func closeOutButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func postButton(_ sender: Any) {
        let array = genPicIDs(array: imageArray)
        let comment: String!
        let mediaType: Int!
        
        if textArea.text != nil {
            comment = textArea.text
        } else {
            comment = ""
        }
        var i = 0
        for path in array {
            let storageRef = Storage.storage().reference().child(path)
            if let picData = imageArray[i].jpegData(compressionQuality: 0.7) {
                storageRef.putData(picData, metadata: nil) { (metadata, error) in
                    guard let metadata = metadata else {
                        print(error!)
                        return
                    }
                    print(metadata)
                }
            }
            i += 1
        }
        let uid = NSUUID().uuidString
        let ref = db.collection("Posts").addDocument(data: [
            "BelongsTo" : Auth.auth().currentUser!.uid,
            "Name" : Auth.auth().currentUser!.displayName as Any,
            "mediaPaths" : array,
            "Comment" : comment,
            "Date" : FieldValue.serverTimestamp(),
            //-1 == Nothing, 0 == Picture, 1 == Video
            "MediaType" : determineMediaType(),
            "uid" : uid
            ]
            ) { (error) in
                if error == nil {
                    self.dismiss(animated: true, completion: nil)
                }
        }
        
        let post = PFObject(className: "Posts")
        post["belongsTo"] = Auth.auth().currentUser?.uid
        post["postName"] = uid
        post.saveInBackground { (success, error) in
            if error == nil {
                print("Success")
            }
        }
        
    }
    
    
    func determineMediaType() -> Int {
        if !imageArray.isEmpty {
            return 0
        } else if videoURL != nil {
            return 1
        }
        return -1
    }
    
    /*
 
     self.textArea.endEditing(true)
     self.scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
     scrollViewBottomAnchor?.isActive = false
     scrollViewBottomAnchor = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50 - (safeAreaBottom ?? 0))
     scrollViewBottomAnchor?.isActive = true
     self.view1.frame = CGRect(x: 0, y: self.view.frame.size.height - 50 - (safeAreaBottom ?? 0), width: self.view.frame.size.width, height: 50)
 
     */
    
    func loadImagesIntoImageViews() {
        if self.imageArray.count == 1 {
            let aspectRatio = self.getAspectRatio(height: self.imageArray[0].size.height, width: self.imageArray[0].size.width)
            self.imageArea.image = self.imageArray[0]
            self.imageAreaWidthConstraint?.isActive = false
            self.imageAreaWidthConstraint = self.imageArea.widthAnchor.constraint(equalToConstant: aspectRatio.screenWidth)
            self.imageAreaWidthConstraint?.isActive = true
            
            
            self.imageAreaHeightConstraint?.isActive = false
            self.imageAreaHeightConstraint = self.imageArea.heightAnchor.constraint(equalToConstant: aspectRatio.screenHeight)
            self.imageAreaHeightConstraint?.isActive = true
            
            UIView.animate(withDuration: 0.3, animations: {
                self.scrollView.contentOffset = CGPoint(x: 0, y: self.imageArea.frame.origin.y + (self.navigationController?.navigationBar.frame.size.height)!)
            })
        } else if self.imageArray.count == 2 {
            let aspectRatio = self.getAspectRatio(height: self.imageArray[1].size.height, width: self.imageArray[1].size.width)
            self.imageArea2.image = self.imageArray[1]
            self.imageAreaBottomConstraint?.isActive = false
            self.imageArea2BottomConstraint?.isActive = true
            self.imageArea2WidthConstraint?.isActive = false
            self.imageArea2WidthConstraint = self.imageArea2.widthAnchor.constraint(equalToConstant: aspectRatio.screenWidth)
            self.imageArea2WidthConstraint?.isActive = true
            
            
            self.imageArea2HeightConstraint?.isActive = false
            self.imageArea2HeightConstraint = self.imageArea2.heightAnchor.constraint(equalToConstant: aspectRatio.screenHeight)
            self.imageArea2HeightConstraint?.isActive = true
            
            
            self.imageArea2BottomConstraint?.isActive = true
            
            UIView.animate(withDuration: 0.3, animations: {
                self.scrollView.contentOffset = CGPoint(x: 0, y: self.imageArea2.frame.origin.y + (self.navigationController?.navigationBar.frame.size.height)!)
            })
        } else if self.imageArray.count == 3 {
            self.imageArea3.image = self.imageArray[2]
            
            let aspectRatio = self.getAspectRatio(height: self.imageArray[2].size.height, width: self.imageArray[2].size.width)
            self.imageArea3.image = self.imageArray[2]
            self.imageArea2BottomConstraint?.isActive = false
            self.imageArea3BottomConstraint?.isActive = true
            self.imageArea3WidthConstraint?.isActive = false
            self.imageArea3WidthConstraint = self.imageArea3.widthAnchor.constraint(equalToConstant: aspectRatio.screenWidth)
            self.imageArea3WidthConstraint?.isActive = true
            
            
            self.imageArea3HeightConstraint?.isActive = false
            self.imageArea3HeightConstraint = self.imageArea3.heightAnchor.constraint(equalToConstant: aspectRatio.screenHeight)
            self.imageArea3HeightConstraint?.isActive = true
            
            
            self.imageArea3BottomConstraint?.isActive = true
            
            UIView.animate(withDuration: 0.3, animations: {
                self.scrollView.contentOffset = CGPoint(x: 0, y: self.imageArea3.frame.origin.y + (self.navigationController?.navigationBar.frame.size.height)!)
            })
        } else if self.imageArray.count == 4 {
            self.imageArea4.image = self.imageArray[3]
            
            let aspectRatio = self.getAspectRatio(height: self.imageArray[3].size.height, width: self.imageArray[3].size.width)
            self.imageArea4.image = self.imageArray[3]
            self.imageArea3BottomConstraint?.isActive = false
            self.imageArea4BottomConstraint?.isActive = true
            self.imageArea4WidthConstraint?.isActive = false
            self.imageArea4WidthConstraint = self.imageArea4.widthAnchor.constraint(equalToConstant: aspectRatio.screenWidth)
            self.imageArea4WidthConstraint?.isActive = true
            
            
            self.imageArea4HeightConstraint?.isActive = false
            self.imageArea4HeightConstraint = self.imageArea4.heightAnchor.constraint(equalToConstant: aspectRatio.screenHeight)
            self.imageArea4HeightConstraint?.isActive = true
            
            
            self.imageArea4BottomConstraint?.isActive = true
            UIView.animate(withDuration: 0.3, animations: {
                self.scrollView.contentOffset = CGPoint(x: 0, y: self.imageArea4.frame.origin.y + (self.navigationController?.navigationBar.frame.size.height)!)
            })
            
            self.pictureButton.isUserInteractionEnabled = false
            
        }
    }
    
    func reloadAllImageViews() {
        if self.imageArray.count >= 1 {
            let aspectRatio = self.getAspectRatio(height: self.imageArray[0].size.height, width: self.imageArray[0].size.width)
            self.imageArea.image = self.imageArray[0]
            self.imageAreaWidthConstraint?.isActive = false
            self.imageAreaWidthConstraint = self.imageArea.widthAnchor.constraint(equalToConstant: aspectRatio.screenWidth)
            self.imageAreaWidthConstraint?.isActive = true
            
            
            self.imageAreaHeightConstraint?.isActive = false
            self.imageAreaHeightConstraint = self.imageArea.heightAnchor.constraint(equalToConstant: aspectRatio.screenHeight)
            self.imageAreaHeightConstraint?.isActive = true
            
            UIView.animate(withDuration: 0.3, animations: {
                self.scrollView.contentOffset = CGPoint(x: 0, y: self.imageArea.frame.origin.y + (self.navigationController?.navigationBar.frame.size.height)!)
            })
        }
        if self.imageArray.count >= 2 {
            let aspectRatio = self.getAspectRatio(height: self.imageArray[1].size.height, width: self.imageArray[1].size.width)
            self.imageArea2.image = self.imageArray[1]
            self.imageAreaBottomConstraint?.isActive = false
            self.imageArea2BottomConstraint?.isActive = true
            self.imageArea2WidthConstraint?.isActive = false
            self.imageArea2WidthConstraint = self.imageArea2.widthAnchor.constraint(equalToConstant: aspectRatio.screenWidth)
            self.imageArea2WidthConstraint?.isActive = true
            
            
            self.imageArea2HeightConstraint?.isActive = false
            self.imageArea2HeightConstraint = self.imageArea2.heightAnchor.constraint(equalToConstant: aspectRatio.screenHeight)
            self.imageArea2HeightConstraint?.isActive = true
            
            
            self.imageArea2BottomConstraint?.isActive = true
            
            UIView.animate(withDuration: 0.3, animations: {
                self.scrollView.contentOffset = CGPoint(x: 0, y: self.imageArea2.frame.origin.y + (self.navigationController?.navigationBar.frame.size.height)!)
            })
        }
        if self.imageArray.count >= 3 {
            self.imageArea3.image = self.imageArray[2]
            
            let aspectRatio = self.getAspectRatio(height: self.imageArray[2].size.height, width: self.imageArray[2].size.width)
            self.imageArea3.image = self.imageArray[2]
            self.imageArea2BottomConstraint?.isActive = false
            self.imageArea3BottomConstraint?.isActive = true
            self.imageArea3WidthConstraint?.isActive = false
            self.imageArea3WidthConstraint = self.imageArea3.widthAnchor.constraint(equalToConstant: aspectRatio.screenWidth)
            self.imageArea3WidthConstraint?.isActive = true
            
            
            self.imageArea3HeightConstraint?.isActive = false
            self.imageArea3HeightConstraint = self.imageArea3.heightAnchor.constraint(equalToConstant: aspectRatio.screenHeight)
            self.imageArea3HeightConstraint?.isActive = true
            
            
            self.imageArea3BottomConstraint?.isActive = true
            
            UIView.animate(withDuration: 0.3, animations: {
                self.scrollView.contentOffset = CGPoint(x: 0, y: self.imageArea3.frame.origin.y + (self.navigationController?.navigationBar.frame.size.height)!)
            })
        }
        if self.imageArray.count >= 4 {
            self.imageArea4.image = self.imageArray[3]
            
            let aspectRatio = self.getAspectRatio(height: self.imageArray[3].size.height, width: self.imageArray[3].size.width)
            self.imageArea4.image = self.imageArray[3]
            self.imageArea3BottomConstraint?.isActive = false
            self.imageArea4BottomConstraint?.isActive = true
            self.imageArea4WidthConstraint?.isActive = false
            self.imageArea4WidthConstraint = self.imageArea4.widthAnchor.constraint(equalToConstant: aspectRatio.screenWidth)
            self.imageArea4WidthConstraint?.isActive = true
            
            
            self.imageArea4HeightConstraint?.isActive = false
            self.imageArea4HeightConstraint = self.imageArea4.heightAnchor.constraint(equalToConstant: aspectRatio.screenHeight)
            self.imageArea4HeightConstraint?.isActive = true
            
            
            self.imageArea4BottomConstraint?.isActive = true
            UIView.animate(withDuration: 0.3, animations: {
                self.scrollView.contentOffset = CGPoint(x: 0, y: self.imageArea4.frame.origin.y + (self.navigationController?.navigationBar.frame.size.height)!)
            })
            
            self.pictureButton.isUserInteractionEnabled = false
            
        }
    }
    
    
    @IBAction func choosePicture(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        if imageArray.count != 0 {
            picker.mediaTypes = ["public.image"]
        } else {
            picker.mediaTypes = ["public.image", "public.movie"]
        }
        present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let im = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            //imageArea.image = im
            imageArray.append(im)
            self.dismiss(animated: true) {
                
                print("Height: ", im.size.height)
                print("Width: ", im.size.width)
                
                self.loadImagesIntoImageViews()
                //let ratio = self.getAspectRatio(height: im!.size.height, width: im!.size.width)
                
                //print(ratio.firstVal, ":", ratio.secondVal)
                
                //self.loadImagesIntoImageViews()
                
                
                
            }
        } else if let infoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            
            videoURL = infoURL
            let vid = resolutionSize(url: videoURL!)
            let aspectRatio = getAspectRatio(height: (vid!.height), width: vid!.width)
            imageAreaTopConstraint?.isActive = false
            
            self.dismiss(animated: true) {
               self.videoView.translatesAutoresizingMaskIntoConstraints = false
                [
                    
                    self.videoView.topAnchor.constraint(equalTo: self.textArea.bottomAnchor, constant: 5),
                    self.videoView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
                    self.videoView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
                    self.videoView.widthAnchor.constraint(equalToConstant: aspectRatio.screenWidth),
                    self.videoView.heightAnchor.constraint(equalToConstant: aspectRatio.screenHeight)
                    
                    
                ].forEach { $0.isActive = true }
                
                
                
                
                //self.playerView!.videoGravity =
                //self.videoView.layer.addSublayer(self.playerView!)
                
            }
            
            self.player = AVPlayer(url: self.videoURL!)
            
            self.playerView = AVPlayerLayer(player: self.player)
            self.playerView?.videoGravity = AVLayerVideoGravity.resizeAspect
            self.playerView!.frame = CGRect(x: 0, y: 0, width: aspectRatio.screenWidth, height: aspectRatio.screenHeight)
            
            self.videoView.layer.insertSublayer(self.playerView!, at: 0)
            
            self.pictureButton.isEnabled = false
            
        }
        
    }
    
    func resolutionSize(url: URL) -> CGSize? {
        guard let track = AVAsset(url: url).tracks(withMediaType: AVMediaType.video).first else { return nil }
        let size = track.naturalSize.applying(track.preferredTransform)
        return CGSize(width: abs(size.width), height: abs(size.height))
    }
    
    
    @IBAction func chooseVideo(_ sender: Any) {
        
        
        
        
    }
    
    @IBAction func cameraClick(_ sender: Any) {
        
        self.performSegue(withIdentifier: "toCamera", sender: self)
        
        
    }
    
    
    
    func getAspectRatio(height: CGFloat, width: CGFloat) -> AspectRatio {
        let viewWidth = self.view.frame.size.width - 20
        let unit = viewWidth/width
        let theHeight = (unit) * height
        let aspectRatio = AspectRatio(screenHeight: theHeight, screenWidth: viewWidth)
        return aspectRatio
    }
    
    
    
    
    @objc func showKeyboard(notification: NSNotification) {
        
        keyboard = ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue)!
        
        y = self.view.frame.size.height - self.keyboard.height - 50
        
        view1.frame = CGRect(x: 0, y: y ?? self.view.frame.size.height, width: self.view.frame.size.width, height: 50)
        view1.backgroundColor = UIColor.groupTableViewBackground
        self.view.addSubview(view1)
       
        scrollViewBottomAnchor?.isActive = false
        scrollViewBottomAnchor = scrollView.heightAnchor.constraint(equalToConstant: self.view.frame.size.height - self.keyboard.height - view1.frame.size.height)
        scrollViewBottomAnchor?.isActive = true
        
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - self.keyboard.height - 50)
        
        
        
    }
    
    @objc func hideKeyboard(notification: NSNotification) {
        scrollViewBottomAnchor?.isActive = false
        scrollViewBottomAnchor = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50 - (safeAreaBottom ?? 0))
        scrollViewBottomAnchor?.isActive = true
        self.view1.frame = CGRect(x: 0, y: self.view.frame.size.height - 50 - (safeAreaBottom ?? 0), width: self.view.frame.size.width, height: 50)
       
    }
    
    func genPicIDs(array: [UIImage]) -> [String] {
        var stringArray = [String]()
        for _ in array {
            let str = NSUUID().uuidString
            let imageName = "\(str).jpg"
            stringArray.append(imageName)
        }
        return stringArray
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

extension NewPostVC: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        print(textView.text)
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        textView.constraints.forEach{
            (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
       
    }
    
}
