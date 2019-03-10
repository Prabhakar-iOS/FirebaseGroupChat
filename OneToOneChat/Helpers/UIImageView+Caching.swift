//
//  UIImageView+Caching.swift
//  OneToOneChat
//
//  Created by Prabhakar G on 10/03/19.
//  Copyright © 2019 Prabhakar G. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func loadImageFromUrlString(urlString: String) {
        self.image = nil
        if let cachedImage = imageCache.object(forKey: NSString(string: urlString)) {
            self.image = cachedImage
            return
        }
        let url = URL(string: urlString)!
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                return
            }
            
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: NSString(string: urlString))
                    self.image = downloadedImage
                }
            }
        }.resume()
    }
}
