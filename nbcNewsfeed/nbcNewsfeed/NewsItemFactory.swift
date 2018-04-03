//
//  NewsItemFactory.swift
//  nbcNewsfeed
//
//  Created by Yossi Katzin on 4/2/18.
//  Copyright © 2018 Yossi Katzin. All rights reserved.
//

import Foundation
import UIKit.UIImage

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
        }
    }
    
    static func createItem(dict: [String : Any]) -> NewsItem? {
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
        guard let teaseURL: String = dict[Keys.NewsItem.tease] as? String else {
            malformedDataError(Keys.NewsItem.tease)
            return nil
        }
        if type == NewsItemType.section {
            newItem = NewsSection(id: id, teaseURL: teaseURL)
            var subItems: [SectionItemProtocol] = []
            if let itemsList: [[String : Any]] = dict[Keys.Section.items] as? [[String : Any]] {
                for subItemDict in itemsList {
                    if let newSubItem = createItem(dict: subItemDict) as? SectionItemProtocol {
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
            guard let url: String = dict[Keys.SectionItem.url] as? String else {
                malformedDataError(Keys.SectionItem.url)
                return nil
            }
            guard let summary: String = dict[Keys.SectionItem.summary] as? String else {
                malformedDataError(Keys.SectionItem.summary)
                return nil
            }
            let breakingLabel: String? = dict[Keys.SectionItem.breakingLabel] as? String
            if type == NewsItemType.article {
                newItem = NewsArticle(id: id, teaseURL: teaseURL, headline: headline, published: published, url: url, summary: summary, breakingLabel: breakingLabel)
            }
        }
        return newItem
    }
    
    static let dateFormatter: ISO8601DateFormatter = {
        var formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullTime, .withFullDate, .withDashSeparatorInDate, .withColonSeparatorInTime]
        return formatter
    }()
}
