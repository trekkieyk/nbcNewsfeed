//
//  NewsSection.swift
//  nbcNewsfeed
//
//  Created by Yossi Katzin on 4/2/18.
//  Copyright © 2018 Yossi Katzin. All rights reserved.
//

import Foundation
import UIKit

class NewsSection: NewsItem {
    override var type: NewsItemType { return .section }
    override func fatalErrorIfBase() { }
    
    private var itemIDs: Set<String> = []
    private var itemDict: [String : SectionItemProtocol] = [:]
    private var items: [SectionItemProtocol] = [] {
        didSet {
            items.sort { (first, second) -> Bool in
                return first.published >= second.published
            }
        }
    }
    
    var itemCount: Int {
        return items.count
    }
    
    func getItem(at index: Int) -> SectionItemProtocol? {
        guard index >= 0 && index < itemCount else {
            return nil
        }
        return items[index]
    }
    
    func getItem(byID id: String) -> SectionItemProtocol? {
        return itemDict[id]
    }
    
    override init(id: String, teaseURL url: String, teaseImage image: UIImage? = nil) {
        super.init(id: id, teaseURL: url, teaseImage: image)
    }
    
    func insertItem(newItem item: SectionItemProtocol) {
        guard itemDict[item.id] == nil else {
            return
        }
        itemDict[item.id] = item
        items.append(item)
    }
    
    func insertItems(newItems: [SectionItemProtocol]) {
        var selected: [SectionItemProtocol] = []
        for item in newItems {
            guard itemDict[item.id] == nil else {
                continue
            }
            itemDict[item.id] = item
            selected.append(item)
        }
        items.append(contentsOf: selected)
    }
}

protocol SectionItemProtocol: NewsItemProtocol {
    var headline: String { get }
    var published: Date { get }
    var url: String { get }
    var summary: String { get }
    var breakingLabel: String? { get }
}
