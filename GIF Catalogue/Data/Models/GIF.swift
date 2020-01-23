//
//  GIF.swift
//  GIF Catalogue
//
//  Created by Geof Crowl on 1/22/20.
//  Copyright © 2020 Geof Crowl. All rights reserved.
//

import UIKit

class GIF: NSObject {
    
    // Ref: https://developers.giphy.com/docs/api/schema#gif-object

//    let type: String
//    let id: String
//    let slug: String
//    let url: String
//    let bitlyUrl: String
//    let embedUrl: String
//    let username: String
//    let source: String
//    let rating: String
//    let contentUrl: String
//    let sourceTld: String
//    let sourcePostUrl: String
//    let updateDatetime: String
//    let createDatetime: String
//    let importDatetime: String
//    let trendingDatetime: String
    // let images: [GiphyImage]
    let title: String
    let image: Image
    
    init?(data: NSDictionary) {
        guard let title = data["title"] as? String,
            let imageData = data["images"] as? NSDictionary
            else { return nil }
        
        self.title = title
        
        if let image = Image(data: imageData) {
            self.image = image
        } else {
            return nil
        }
    }
    
}
