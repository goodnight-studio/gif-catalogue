//
//  Image.swift
//  GIF Catalogue
//
//  Created by Geof Crowl on 1/22/20.
//  Copyright © 2020 Geof Crowl. All rights reserved.
//

import UIKit
import FLAnimatedImage

class Image: NSObject {

    let fixedWidthUrl: URL?
    var fixedWidthData: Data?
    var fixedWidthImage: UIImage? {
        return fixedWidthData != nil ? UIImage(data: fixedWidthData!) : nil
    }
    
    let originalImageUrl: URL?
    var originalImageData: Data?
    
    var originalImage: FLAnimatedImage?
    
    init?(data: NSDictionary) {
        
        guard let fixedWidth = data["fixed_width_downsampled"] as? NSDictionary,
            let original = data["downsized_large"] as? NSDictionary
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
    }
    
    func loadOriginalImage(completion: ((_ image: FLAnimatedImage) -> Void)? ) {
        if let originalImageData = originalImageData {
            
//            originalImage = UIImage(data: originalImageData)
            originalImage = FLAnimatedImage(animatedGIFData: originalImageData)
            print("done loading original.")
            completion?(originalImage!)
            
        } else {
            
            guard let _originalImageData = try? Data(contentsOf: self.originalImageUrl!) else { return }
            
            originalImageData = _originalImageData
            
            originalImage = FLAnimatedImage(animatedGIFData: originalImageData)
            print("done loading original.")
            completion?(originalImage!)
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
