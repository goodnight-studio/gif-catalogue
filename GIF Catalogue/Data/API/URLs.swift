//
//  URLs.swift
//  GIF Catalogue
//
//  Created by Geof Crowl on 1/22/20.
//  Copyright © 2020 Geof Crowl. All rights reserved.
//

import UIKit

class URLs: NSObject {

    static var trending: URL {
        return URL(string: "https://api.giphy.com/v1/gifs/trending")!
    }
    
}
