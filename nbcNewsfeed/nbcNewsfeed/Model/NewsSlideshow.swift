//
//  NewsSlideshow.swift
//  nbcNewsfeed
//
//  Created by Yossi Katzin on 4/10/18.
//  Copyright © 2018 Yossi Katzin. All rights reserved.
//

import Foundation
import UIKit.UIImage
import CoreData

class NewsSlideshow: NewsSectionItem {
    
    @NSManaged private var imagesIDs: [String]
    @NSManaged private(set) var images: Set<NewsSlideshowItem>
    private var imagesDict: [String : NewsSlideshowItem] = [:]
    private(set) var tallestHeightToWidth: CGFloat?
    
    override func fatalErrorIfBase() {}
    
    override class var entityName: String {
        return "NewsSlideshowEntity"
    }
    
    override var mediaHeightToWidth: CGFloat? {
        return tallestHeightToWidth ?? imageHeightToWidth
    }
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
        var tallest: CGFloat?
        for image in images {
            imagesDict[image.id] = image
            if let ratio = image.mediaHeightToWidth, ratio > (tallest ?? 0.0) {
                tallest = ratio
            }
        }
        tallestHeightToWidth = tallest
    }
    
    override init(id: String, teaseURL: URL, teaseImageData: Data? = nil, entity: NSEntityDescription? = nil, headline: String, published: Date, url: URL, summary: String, breakingLabel: String?) {
        var entityToUse = entity
        if entityToUse == nil {
            entityToUse = NSEntityDescription.entity(forEntityName: NewsSlideshow.entityName, in: NewsItemFactory.shared.persistentcontainer.viewContext)
        }
        super.init(id: id, teaseURL: teaseURL, teaseImageData: teaseImageData, entity: entityToUse, headline: headline, published: published, url: url, summary: summary, breakingLabel: breakingLabel)
    }
    
    func updateItems(items: [NewsSlideshowItem]) {
        var ids: [String] = []
        var images: Set<NewsSlideshowItem> = []
        var dict: [String : NewsSlideshowItem] = [:]
        var tallest: CGFloat?
        
        for item in items {
            ids.append(item.id)
            images.insert(item)
            dict[item.id] = item
            if let ratio = item.mediaHeightToWidth, ratio > (tallest ?? 0.0) {
                tallest = ratio
            }
        }
        self.imagesDict = dict
        self.images = images
        self.imagesIDs = ids
        tallestHeightToWidth = tallest
    }
    
    var uiImages: [UIImage] {
        var uiImages: [UIImage] = []
        for id in imagesIDs {
            if let image = imagesDict[id]?.image {
                uiImages.append(image)
            }
        }
        return uiImages
    }
}
