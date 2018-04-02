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
    static func createItem(dict: [String : Any]) -> NewsItem? {
        let malformedDataError: (String) -> () = {(key: String) in
            print("The dictionary is missing the key '\(key)'")
        }
        var newItem: NewsItem? = nil
        guard let typeStr: String = dict[BaseNewsItem.typeKey] as? String, let type: NewsItemType = NewsItemType(rawValue: typeStr) else {
            malformedDataError(BaseNewsItem.typeKey)
            return nil
        }
        guard let id = dict[BaseNewsItem.idKey] as? String else {
            malformedDataError(BaseNewsItem.idKey)
            return nil
        }
        guard let teaseURL: String = dict[BaseNewsItem.teaseKey] as? String else {
            malformedDataError(BaseNewsItem.teaseKey)
            return nil
        }
        switch type {
        case NewsItemType.section:
            newItem = NewsSection(id: id, teaseURL: teaseURL)
        default:
            break
        }
        return newItem
    }
}
