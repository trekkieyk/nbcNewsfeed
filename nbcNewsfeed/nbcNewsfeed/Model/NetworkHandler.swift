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
import AVFoundation.AVAsset

class NetworkHandler {
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
                let section: NewsItem? = NewsItemFactory.shared.getOrCreateItem(dict: parsedData)
                print()
                let otherData = parsedData
                print(section?.id ?? "")
            } catch let error as NSError {
                print(error)
            }
        }.resume()
    }
    
    static func getData(count: Int? = nil, callback: @escaping ([AnyObject]) -> ()) {
        var urlString = feedUrl
        if let count = count, count > 0 {
            urlString += "size=\(count)"
        }
        guard let url = urlFromString(str: urlString) else {
            return
        }
        URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            var completedNormally = false
            defer {
                if !completedNormally {
                    callback([])
                }
            }
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is missing")
                return
            }
            do {
                guard let parsedData: [AnyObject] = try JSONSerialization.jsonObject(with: data) as? [AnyObject] else {
                    print("Data is malformed")
                    return
                }
                completedNormally = true
                callback(parsedData)
            } catch let error as NSError {
                print(error)
            }
            }.resume()
    }
    
    private static var fetchesForURL: [URL : [(Data) -> ()]] = [:]
    
    private static var imageFetchQueue: DispatchQueue = DispatchQueue(label: "imageFetcher", qos: DispatchQoS.utility)
    
    static func fetchImage(url urlStr: String, successHandler: @escaping (Data) -> ()) {
        guard let url = urlFromString(str: urlStr) else {
            return
        }
        fetchImage(url: url, successHandler: successHandler)
    }
    
    static func fetchImage(url: URL, successHandler: @escaping (Data) -> ()) {
        imageFetchQueue.async {
            guard fetchesForURL[url] == nil else {
                fetchesForURL[url]?.append(successHandler)
                return
            }
            fetchesForURL[url] = []
            fetchesForURL[url]?.append(successHandler)
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    var i = 0
                    while i < fetchesForURL[url]?.count ?? 0 {
                        fetchesForURL[url]?[i](data)
                        i += 1
                    }
                }
                fetchesForURL[url] = nil
                }.resume()
        }
    }
    
    static func fetchVideo(url: URL, successHandler: @escaping (AVAsset) -> ()) {
        imageFetchQueue.async {
            let asset = AVAsset(url: url)
            successHandler(asset)
        }
    }
    
    static func urlFromString(str: String) -> URL? {
        let url = URL(string: str)
        if url == nil {
            print("Failed to create URL from '\(str)'")
        }
        return url
    }
}
