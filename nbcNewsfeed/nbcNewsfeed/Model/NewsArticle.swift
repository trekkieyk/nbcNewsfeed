//
//  NewsArticle.swift
//  nbcNewsfeed
//
//  Created by Yossi Katzin on 4/2/18.
//  Copyright © 2018 Yossi Katzin. All rights reserved.
//

import Foundation
import UIKit.UIImage
import CoreData

class NewsArticle: NewsSectionItem {
    
    override var type: NewsItemType {
        return .article
    }
    
    override class var entityName: String {
        return "NewsArticleEntity"
    }
    
    override func fatalErrorIfBase() { }
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    override init(id: String, teaseURL: URL, teaseImageData: Data? = nil, entity: NSEntityDescription? = nil, headline: String, published: Date, url: URL, summary: String, breakingLabel: String? = nil) {
        var entityToUse = entity
        if entityToUse == nil {
            entityToUse = NSEntityDescription.entity(forEntityName: NewsArticle.entityName, in: NewsItemFactory.shared.persistentcontainer.viewContext)
        }
        super.init(id: id, teaseURL: teaseURL, teaseImageData: teaseImageData, entity: entityToUse, headline: headline, published: published, url: url, summary: summary, breakingLabel: breakingLabel)
    }
}
