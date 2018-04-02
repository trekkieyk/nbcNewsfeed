//
//  NewsItemModel.swift
//  nbcNewsfeed
//
//  Created by Yossi Katzin on 4/2/18.
//  Copyright © 2018 Yossi Katzin. All rights reserved.
//

import Foundation
import UIKit

protocol NewsItem: class {
    var id: String { get set }
    var teaseURL: String { get set }
    var teaseImage: UIImage? { get set }
    var type: NewsItemType { get }
    static var idKey: String { get }
    static var teaseKey: String { get }
    static var typeKey: String { get }
}

enum NewsItemType: String {
    case section = "Section"
    case article = "article"
    case video = "video"
    case slideshow = "slideshow"
    case none = "NONE"
}

extension NewsItem {
    static var idKey: String {
        return "id"
    }
    static var teaseKey: String {
        return "tease"
    }
    static var typeKey: String {
        return "type"
    }
    func sharedInit(id: String, teaseURL: String, teaseImage: UIImage? = nil) {
        self.id = id
        self.teaseURL = teaseURL
        self.teaseImage = teaseImage
        if teaseImage == nil {
            FeedFetchHandler.fetchImage(url: self.teaseURL, successHandler: {[weak self] (image) in
                self?.teaseImage = image
            })
        }
    }
}

class BaseNewsItem: NewsItem {
    var id: String = ""
    
    var teaseURL: String = ""
    
    var teaseImage: UIImage? = nil
    
    var type: NewsItemType {
        return .none
    }
    
    func fatalErrorIfBase() {
        fatalError("Please don't create an instance of this class")
    }
    
    init(id: String, teaseURL: String, teaseImage: UIImage? = nil) {
        sharedInit(id: id, teaseURL: teaseURL, teaseImage: teaseImage)
        fatalErrorIfBase()
    }
}
