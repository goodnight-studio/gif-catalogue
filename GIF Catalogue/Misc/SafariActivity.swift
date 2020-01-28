//
//  SafariActivity.swift
//  Air Lookout
//
//  Created by Geof Crowl on 6/21/19.
//  Copyright © 2019 Geof Crowl. All rights reserved.
//

import UIKit

class SafariActivity: UIActivity {
    
    var url: URL?
    
    override var activityType: UIActivity.ActivityType? {
        return .init("OpenInSafari")
    }

    override var activityTitle: String? {
        return "Open in Safari"
    }
    
    override var activityImage: UIImage? {
        return UIImage(systemName: "safari")
    }
    
    override class var activityCategory: UIActivity.Category {
        return .share
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        
        for item in activityItems {
            if let _ = item as? URL {
                return true
            }
        }
        return false
    }
    
    override func prepare(withActivityItems activityItems: [Any]) {
        
        for item in activityItems {
            
            if let _url = item as? URL {
                
                url = _url
                return
            }
        }
    }
    
    override func perform() {
        
        guard let url = url else {
            return
        }
        
        UIApplication.shared.open(url, options: [:])
    }
}
