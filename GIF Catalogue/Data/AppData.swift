//
//  AppData.swift
//  GIF Catalogue
//
//  Created by Geof Crowl on 1/22/20.
//  Copyright © 2020 Geof Crowl. All rights reserved.
//

import UIKit

class AppData: NSObject {
    
    static var trendingGifs: [GIF]? {
        
        didSet {
            preload(gifs: trendingGifs)
        }
    }
    
    static var searchGifs: [GIF]? {
        
        didSet {
            preload(gifs: searchGifs)
        }
    }
    
    static func preload(gifs: [GIF]?) {
        
        guard let gifs = gifs else { return }
        
        for gif in gifs {
            gif.image.loadFixedWidthData(completion: nil)
        }
    }
    
    
    static var shared = AppData()
    
    private override init() { }
}
