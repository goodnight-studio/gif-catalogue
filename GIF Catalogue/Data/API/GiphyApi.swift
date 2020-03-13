//
//  GiphyApi.swift
//  GIF Catalogue
//
//  Created by Geof Crowl on 1/22/20.
//  Copyright © 2020 Geof Crowl. All rights reserved.
//

import UIKit

class GiphyApi {
    
    typealias CompletionHandler = (() -> Void)
    typealias ErrorHandler = ((_ error: Error?) -> Void)
    
    static func getTrending(completion: @escaping CompletionHandler, errorHandler: @escaping ErrorHandler) {
        
        GiphyRequest.make(for: URLs.trending, completion: { (_ data: NSDictionary) in
            
            guard let gifs = handleGifData(data: data) else { return errorHandler(nil) }
            
            AppData.trendingGifs = gifs
            
            DispatchQueue.main.async {
                completion()
            }

        }, errorHandler: { (_ error: Error?) in
            print("error:", error?.localizedDescription ?? "nil")
        })

    }
    
    static func search(query: String, completion: @escaping CompletionHandler, errorHandler: @escaping ErrorHandler) {
        
        guard let url = URLs.search(query: query) else { errorHandler(nil); return }
        
        GiphyRequest.make(for: url, completion: { (_ data: NSDictionary) in
            
            guard let gifs = handleGifData(data: data) else { return errorHandler(nil)}
            
            AppData.searchGifs = gifs
            
            DispatchQueue.main.async {
                completion()
            }
            
        }, errorHandler: { (_ error: Error?) in
            print("error:", error?.localizedDescription ?? "nil")
        })
    }
    
    static func handleGifData(data: NSDictionary) -> [GIF]? {
        
        guard let gifsData = data["data"] as? NSArray else { return nil }
        
        var gifs = [GIF]()
        
        for itemData in gifsData {
            guard let itemData = itemData as? NSDictionary else { continue }
            if let gif = GIF(data: itemData) {
                gifs.append(gif)
            }
        }
        
        return gifs
    }

}
