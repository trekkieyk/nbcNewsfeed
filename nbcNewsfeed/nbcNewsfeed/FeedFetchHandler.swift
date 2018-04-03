//
//  FeedHandler.swift
//  nbcNewsfeed
//
//  Handles fetching the newsfeed from the network
//
//  Created by Yossi Katzin on 4/2/18.
//  Copyright © 2018 Yossi Katzin. All rights reserved.
//

import Foundation
import UIKit.UIImage

class FeedFetchHandler {
    static let feedUrl = "http://msgviewer.nbcnewstools.net:9207/v1/query/curation/news/?"
    
    static func getData(count: Int? = nil) {
        var urlString = feedUrl
        if let count = count, count > 0 {
            urlString += "size=\(count)"
        }
        guard let url = urlFromString(str: urlString) else {
            return
        }
        URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is missing")
                return
            }
            do {
                guard let parsedData: [String : Any] = (try JSONSerialization.jsonObject(with: data) as? [AnyObject])?[0] as? [String : Any] else {
                    print("Data is malformed")
                    return
                }
                let section: NewsItem? = NewsItemFactory.createItem(dict: parsedData)
                print()
                let otherData = parsedData
                print(section?.id ?? "")
            } catch let error as NSError {
                print(error)
            }
        }.resume()
    }
    
    static func fetchImage(url urlStr: String, successHandler: @escaping (UIImage) -> ()) {
        guard let url = urlFromString(str: urlStr) else {
            return
        }
        fetchImage(url: url, successHandler: successHandler)
    }
    
    static func fetchImage(url: URL, successHandler: @escaping (UIImage) -> ()) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                successHandler(image)
            }
        }.resume()
    }
    
    static func urlFromString(str: String) -> URL? {
        let url = URL(string: str)
        if url == nil {
            print("Failed to create URL from '\(str)'")
        }
        return url
    }
}
