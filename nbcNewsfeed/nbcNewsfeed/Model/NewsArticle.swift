//
//  NewsArticle.swift
//  nbcNewsfeed
//
//  Created by Yossi Katzin on 4/2/18.
//  Copyright © 2018 Yossi Katzin. All rights reserved.
//

import Foundation
import UIKit.UIImage

class NewsArticle: NewsItem, SectionItemProtocol {
    private(set) var headline: String
    private(set) var published: Date
    private(set) var url: String
    private(set) var summary: String
    private(set) var breakingLabel: String?
    
    override var type: NewsItemType {
        return .article
    }
    
    override func fatalErrorIfBase() { }
    
    init(id: String, teaseURL: String, teaseImage: UIImage? = nil, headline: String, published: Date, url: String, summary: String, breakingLabel: String? = nil) {
        self.headline = headline
        self.published = published
        self.url = url
        self.summary = summary
        self.breakingLabel = breakingLabel
        super.init(id: id, teaseURL: teaseURL, teaseImage: teaseImage)
    }
}
