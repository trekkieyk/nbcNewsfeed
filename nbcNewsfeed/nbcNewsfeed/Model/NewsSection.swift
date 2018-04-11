//
//  NewsSection.swift
//  nbcNewsfeed
//
//  Created by Yossi Katzin on 4/2/18.
//  Copyright © 2018 Yossi Katzin. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class NewsSection: NewsItem {
    override var type: NewsItemType { return .section }
    @NSManaged private(set) var header: String?
    @NSManaged private(set) var subHeader: String?
    override func fatalErrorIfBase() { }
    
    private var itemDict: [String : NewsSectionItem] = [:]
    @NSManaged private var itemSet: Set<NewsSectionItem>
    private var items: [NewsSectionItem] = []
    
    private func sortItems() {
        items.sort { (first, second) -> Bool in
            return first.published >= second.published
        }
    }
    
    var itemCount: Int {
        return items.count
    }
    
    override class var entityName: String {
        return "NewsSectionEntity"
    }
    
    func getItem(at index: Int) -> NewsSectionItem? {
        guard index >= 0 && index < itemCount else {
            return nil
        }
        return items[index]
    }
    
    func getItem(byID id: String) -> NewsSectionItem? {
        return itemDict[id]
    }
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    convenience init(id: String, teaseURL url: URL, teaseImageData imageData: Data? = nil, header: String? = nil, subHeader: String? = nil) {
        self.init(id: id, teaseURL: url, teaseImageData: imageData)
        self.header = header
        self.subHeader = subHeader
    }
    
    private override init(id: String, teaseURL: URL, teaseImageData: Data?, entity: NSEntityDescription? = nil) {
        var entityToUse = entity
        if entityToUse == nil {
            entityToUse = NSEntityDescription.entity(forEntityName: NewsSection.entityName, in: NewsItemFactory.shared.persistentcontainer.viewContext)
        }
        super.init(id: id, teaseURL: teaseURL, teaseImageData: teaseImageData, entity: entityToUse)
        self.header = ""
        self.subHeader = ""
        self.items = []
    }
    
    func insertItem(newItem item: NewsSectionItem) {
        guard itemDict[item.id] == nil else {
            return
        }
        itemDict[item.id] = item
        itemSet.insert(item)
        items.append(item)
        sortItems()
    }
    
    func insertItems(newItems: [NewsSectionItem]) {
        var selected: [NewsSectionItem] = []
        for item in newItems {
            guard itemDict[item.id] == nil else {
                continue
            }
            itemDict[item.id] = item
            selected.append(item)
        }
        itemSet.formUnion(selected)
        items.append(contentsOf: selected)
        sortItems()
    }
    
    override func awakeFromFetch() {
        super.awakeFromFetch()
        itemSet = itemSet.filter({ (item) -> Bool in
            let keep = Calendar.current.isDateInYesterday(item.published) || Calendar.current.isDateInToday(item.published)
            if !keep {
                NewsItemFactory.shared.deregisterItem(item)
                // TODO: this isn't successfully deleting the stale items.
                NewsItemFactory.shared.persistentcontainer.viewContext.delete(item as NSManagedObject)
            }
            return keep
        })
        insertItems(newItems: Array<NewsSectionItem>(itemSet))
    }
    
    func updateFromNetwork(teaseURL: URL, header: String?, subHeader: String?) {
        updateFromNetwork(teaseURL: teaseURL)
        self.header = header
        self.subHeader = subHeader
    }
}
