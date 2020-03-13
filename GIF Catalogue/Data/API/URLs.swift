//
//  URLs.swift
//  GIF Catalogue
//
//  Created by Geof Crowl on 1/22/20.
//  Copyright © 2020 Geof Crowl. All rights reserved.
//

import UIKit

class URLs: NSObject {
    
    static var baseURL: String {
        return "https://api.giphy.com/v1/gifs"
    }

    static var trending: URL {
        return URL(string: "\(baseURL)/trending")!
    }
    
    static func search(query: String) -> URLComponents? {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return nil }
        let url = URL(string: "\(baseURL)/search")!
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: Globals.giphyApiKey),
            URLQueryItem(name: "q", value: query)
        ]
        
        return urlComponents
    }
    
}
