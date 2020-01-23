//
//  AppData.swift
//  GIF Catalogue
//
//  Created by Geof Crowl on 1/22/20.
//  Copyright © 2020 Geof Crowl. All rights reserved.
//

import UIKit

class AppData: NSObject {
    
    static var trendingGifs: [GIF]?
    static var shared = AppData()
    
    private override init() { }
}
