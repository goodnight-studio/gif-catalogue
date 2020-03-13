//
//  GiphyRequest.swift
//  GIF Catalogue
//
//  Created by Geof Crowl on 1/22/20.
//  Copyright © 2020 Geof Crowl. All rights reserved.
//

import UIKit

class GiphyRequest: NSObject {
    
    var shared = GiphyRequest()
    
    typealias CompletionHandler = ((_ responseData: NSDictionary) throws -> Void)
    typealias ErrorHandler = ((_ error: Error?) -> Void)
    
    private override init() { } // Singleton

    
    static func make(for requestURL: URL,
                     completion: @escaping CompletionHandler,
                     errorHandler: @escaping ErrorHandler) {
        
        var urlComponents = URLComponents(url: requestURL, resolvingAgainstBaseURL: true)!
        
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: Globals.giphyApiKey)
        ]
        
        GiphyRequest.make(for: urlComponents, completion: completion, errorHandler: errorHandler)
        
    }
    
    static func make(for urlComponents: URLComponents,
                     completion: @escaping CompletionHandler,
                     errorHandler: @escaping ErrorHandler) {
        
        let session = URLSession.shared
        session.configuration.allowsCellularAccess = true
        session.configuration.waitsForConnectivity = true
        session.configuration.timeoutIntervalForRequest = 60
        session.configuration.timeoutIntervalForResource = 60
        
        print("URL:", urlComponents.url!)
        
        let task = session.dataTask(with: urlComponents.url!) {
            (data, response, error) in
            
            // if there is an error
            if let error = error {
                print("Request - dataTask: No data for \(urlComponents.url!)!")
                print("Request - dataTask:", error)
                print("Request - dataTask:", error.localizedDescription)
                errorHandler(error)
                return
            }
            
            // make sure there's data
            guard let rawData = data else {
                print("Request - dataTask: Did not receive data for \(urlComponents.url!)")
                errorHandler(nil)
                return
            }
            
            // try to parse
            let options: JSONSerialization.ReadingOptions = [.mutableContainers, .allowFragments]
            let convertedJSON = try? JSONSerialization.jsonObject(with: rawData, options: options)
            
            if let convertedData = convertedJSON as? NSDictionary {
                
                print("Request: convertedData JSON -> NSDictionary is success!")
                
                do {
                    try completion(convertedData)
                } catch let error {
                    errorHandler(error)
                }
                
            } else {
                print("Request: convertedData is nil!")
                errorHandler(nil)
                return
            }
        }
        
        task.resume()
    }
}
