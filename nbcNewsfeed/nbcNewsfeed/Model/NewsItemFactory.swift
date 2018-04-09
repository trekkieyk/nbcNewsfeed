//
//  NewsItemFactory.swift
//  nbcNewsfeed
//
//  Created by Yossi Katzin on 4/2/18.
//  Copyright © 2018 Yossi Katzin. All rights reserved.
//

import Foundation
import UIKit.UIImage
import CoreData

class NewsItemFactory {
    struct Keys {
        struct NewsItem {
            static let id               = "id"
            static let tease            = "tease"
            static let type             = "type"
        }
        struct SectionItem {
            static let headline         = "headline"
            static let published        = "published"
            static let url              = "url"
            static let summary          = "summary"
            static let breakingLabel    = "breakingLabel"
        }
        struct Section {
            static let items            = "items"
            static let header           = "header"
            static let subHeader        = "subHeader"
        }
    }
    
    private(set) static var shared: NewsItemFactory = NewsItemFactory()
    
    weak var persistentcontainer: NSPersistentContainer!
    
    private var allItems: [String : NewsItem] = [:]
    private(set) var sections: [NewsSection] = []
    
    func fetchItemsFromCoreData() {
        let fetchRequest = NSFetchRequest<NewsSection>(entityName: NewsSection.entityName)
        do {
            sections = try persistentcontainer.viewContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Couldn't fetch from Core Data. \(error), \(error.userInfo)")
        }
    }
    
    func fetchItems() {
        if sections.isEmpty {
            fetchItemsFromCoreData()
        }
        NetworkHandler.getData {[weak self] (sections) in
            var newSections: [NewsSection] = []
            for case let jsonSection as [String : Any] in sections {
                if let newSection = self?.getOrCreateItem(dict: jsonSection) as? NewsSection {
                    newSections.append(newSection)
                }
            }
            self?.sections = newSections
            NotificationCenter.default.post(Notification(name: Notifications.Factory.sectionsUpdated))
        }
    }
    
    func getOrCreateItem(dict: [String : Any]) -> NewsItem? {
        let malformedDataError: (String) -> () = {(key: String) in
            print("The dictionary is missing the key '\(key)'")
        }
        var newItem: NewsItem? = nil
        guard let typeStr: String = dict[Keys.NewsItem.type] as? String, let type: NewsItemType = NewsItemType(rawValue: typeStr) else {
            malformedDataError(Keys.NewsItem.type)
            return nil
        }
        guard let id = dict[Keys.NewsItem.id] as? String else {
            malformedDataError(Keys.NewsItem.id)
            return nil
        }
        newItem = allItems[id]
        guard let teaseURLStr: String = dict[Keys.NewsItem.tease] as? String, let teaseURL = URL(string: teaseURLStr) else {
            malformedDataError(Keys.NewsItem.tease)
            return nil
        }
        if type == NewsItemType.section {
            let header = dict[Keys.Section.header] as? String
            let subHeader = dict[Keys.Section.subHeader] as? String
            if let section = newItem as? NewsSection {
                section.updateFromNetwork(teaseURL: teaseURL, header: header, subHeader: subHeader)
            } else {
                newItem = NewsSection(id: id, teaseURL: teaseURL, header: header, subHeader: subHeader)
            }
            var subItems: [NewsSectionItem] = []
            if let itemsList: [[String : Any]] = dict[Keys.Section.items] as? [[String : Any]] {
                for subItemDict in itemsList {
                    if let newSubItem = getOrCreateItem(dict: subItemDict) as? NewsSectionItem {
                        subItems.append(newSubItem)
                    }
                }
                (newItem! as! NewsSection).insertItems(newItems: subItems)
            }
        } else {
            guard let headline: String = dict[Keys.SectionItem.headline] as? String else {
                malformedDataError(Keys.SectionItem.headline)
                return nil
            }
            guard let publishedStr: String = dict[Keys.SectionItem.published] as? String, let published: Date = dateFormatter.date(from: publishedStr) else {
                malformedDataError(Keys.SectionItem.published)
                return nil
            }
            guard let urlStr: String = dict[Keys.SectionItem.url] as? String, let url = URL(string: urlStr) else {
                malformedDataError(Keys.SectionItem.url)
                return nil
            }
            guard let summary: String = dict[Keys.SectionItem.summary] as? String else {
                malformedDataError(Keys.SectionItem.summary)
                return nil
            }
            let breakingLabel: String? = dict[Keys.SectionItem.breakingLabel] as? String
            if type == NewsItemType.article {
                if let article = newItem as? NewsArticle {
                    article.updateFromNetwork(teaseURL: teaseURL, headline: headline, published: published, url: url, summary: summary, breakingLabel: breakingLabel)
                } else {
                    newItem = NewsArticle(id: id, teaseURL: teaseURL, headline: headline, published: published, url: url, summary: summary, breakingLabel: breakingLabel)
                }
            }
        }
        if newItem != nil {
            allItems[newItem!.id] = newItem!
            print("\(newItem!.id) created")
        }
        return newItem
    }
    
    let dateFormatter: ISO8601DateFormatter = {
        var formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullTime, .withFullDate, .withDashSeparatorInDate, .withColonSeparatorInTime]
        return formatter
    }()
    
    func registerItem(_ item: NewsItem) {
        allItems[item.id] = item
    }
}
