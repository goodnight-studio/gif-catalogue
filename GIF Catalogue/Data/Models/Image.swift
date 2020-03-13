//
//  Image.swift
//  GIF Catalogue
//
//  Created by Geof Crowl on 1/22/20.
//  Copyright © 2020 Geof Crowl. All rights reserved.
//

import UIKit

class Image: NSObject {

    let fixedWidthUrl: URL?
    var fixedWidthData: Data?
    
    let originalImageUrl: URL?
    var originalImageData: Data?
    
    var originalImage: UIImage?
    
    init?(data: NSDictionary) {
        
        guard let fixedWidth = data["fixed_width"] as? NSDictionary,
            let original = data["original"] as? NSDictionary
            else { return nil }
        
        if let fixedWidthUrlStr = fixedWidth["url"] as? String {
            self.fixedWidthUrl = URL(string: fixedWidthUrlStr)
        } else {
            return nil
        }
        
        if let originalImageUrlStr = original["url"] as? String {
            self.originalImageUrl = URL(string: originalImageUrlStr)
        } else {
            return nil
        }
        
        super.init()
        
        loadOriginalImage()
    }
    
    func loadOriginalImage() {
        if let originalImageData = originalImageData {
            
            originalImage = UIImage(data: originalImageData)
            
        } else {
            
            guard let _originalImageData = try? Data(contentsOf: self.originalImageUrl!) else { return }
            
            originalImageData = _originalImageData
            
            originalImage = UIImage(data: _originalImageData)
        }
    }
    
    func loadFixedWidthData(completion: ((_ data: Data) -> Void)? = nil ) {
        
        if let fixedWidthData = fixedWidthData {
            
            completion?(fixedWidthData)
            
        } else {
        
            guard let _fixedWidthData = try? Data(contentsOf: self.fixedWidthUrl!) else { return }
            
            fixedWidthData = _fixedWidthData
            
            completion?(_fixedWidthData)
        }
    }
}
