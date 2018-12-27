//
//  Extensions.swift
//  Vriends
//
//  Created by Tanner Luke on 9/16/18.
//  Copyright © 2018 Tanner Luke. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    
    
    func getProfilePic(path: String) {
        
        
        
        self.image = nil 
        
        if let cachedImage = imageCache.object(forKey: path as AnyObject) as? UIImage {
            self.image = cachedImage
        }
 
        
        let url = URL(string: path)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            
            
            if error != nil {
                print(error!)
                return
            }
            
            
            DispatchQueue.main.async(execute: {
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: path as AnyObject)
                    self.image = downloadedImage
                    print("downloaded image is: ", downloadedImage)
                } else {
                    print("there was an error")
                }
                
                
                
                
            })
            }.resume()
        
    }

}
