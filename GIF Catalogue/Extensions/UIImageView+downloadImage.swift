//
//  UIImageView+downloadImage.swift
//  GIF Catalogue
//
//  Created by Geof Crowl on 2/5/20.
//  Copyright © 2020 Geof Crowl. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func downloadImage(url: URL, completion: (() -> Void)? = nil ) {
        
        DispatchQueue.global().async {
            
            guard let data = try? Data(contentsOf: url) else { return }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
                self.contentMode = .scaleAspectFit
                
                completion?()
            }
        }
    }

}

