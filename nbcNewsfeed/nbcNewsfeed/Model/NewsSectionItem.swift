//
//  NewsSectionItem.swift
//  nbcNewsfeed
//
//  Created by Yossi Katzin on 4/9/18.
//  Copyright © 2018 Yossi Katzin. All rights reserved.
//

import Foundation
import CoreData

protocol SectionItemProtocol: NewsItemProtocol {
    var headline: String { get }
    var published: Date { get }
    var url: URL { get }
    var summary: String { get }
    var breakingLabel: String? { get }
}

class NewsSectionItem: NewsItem {
    @NSManaged private(set) var headline: String
    @NSManaged private(set) var published: Date
    @NSManaged private(set) var url: URL
    @NSManaged private(set) var summary: String
    @NSManaged private(set) var breakingLabel: String?
    
    override class var entityName: String {
        return "NewsSectionItemEntity"
    }
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(id: String, teaseURL: URL, teaseImageData: Data?, entity: NSEntityDescription? = nil, headline: String, published: Date, url: URL, summary: String, breakingLabel: String? = nil) {
        var entityToUse = entity
        if entityToUse == nil {
            entityToUse = NSEntityDescription.entity(forEntityName: NewsSectionItem.entityName, in: NewsItemFactory.shared.persistentcontainer.viewContext)
        }
        super.init(id: id, teaseURL: teaseURL, teaseImageData: teaseImageData, entity: entityToUse)
        self.headline = headline
        self.published = published
        self.url = url
        self.summary = summary
        self.breakingLabel = breakingLabel
    }
    
    func updateFromNetwork(teaseURL: URL, headline: String, published: Date, url: URL, summary: String, breakingLabel: String?) {
        updateFromNetwork(teaseURL: teaseURL)
        self.headline = headline
        self.published = published
        self.url = url
        self.summary = summary
        self.breakingLabel = breakingLabel
    }
}
