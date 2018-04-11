//
//  NewsSlideshowItem.swift
//  nbcNewsfeed
//
//  Created by Yossi Katzin on 4/10/18.
//  Copyright © 2018 Yossi Katzin. All rights reserved.
//

import Foundation
import CoreData
import UIKit.UIImage

class NewsSlideshowItem: NewsItem {
    override class var entityName: String {
        return "NewsSlideshowItemEntity"
    }
    
    override var type: NewsItemType {
        return .slideshowImage
    }
    
    override func fatalErrorIfBase() {}
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(id: String, imageURL: URL, imageData: Data? = nil, entity: NSEntityDescription? = nil) {
        var entityToUse = entity
        if entityToUse == nil {
            entityToUse = NSEntityDescription.entity(forEntityName: NewsSlideshowItem.entityName, in: NewsItemFactory.shared.persistentcontainer.viewContext)
        }
        super.init(id: id, teaseURL: imageURL, teaseImageData: imageData, entity: entityToUse)
    }
    
    var imageURL: URL {
        return teaseURL
    }
    
    var image: UIImage? {
        return teaseImage
    }
}
