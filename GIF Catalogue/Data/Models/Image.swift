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
    
    init?(data: NSDictionary) {
        guard let fixedWidth = data["fixed_width"] as? NSDictionary
            else { return nil }
        
        if let fixedWidthUrlStr = fixedWidth["url"] as? String {
            self.fixedWidthUrl = URL(string: fixedWidthUrlStr)
        } else {
            return nil
        }
    }
}
