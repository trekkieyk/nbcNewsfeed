//
//  NewsItemModel.swift
//  nbcNewsfeed
//
//  Created by Yossi Katzin on 4/2/18.
//  Copyright © 2018 Yossi Katzin. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol NewsItemProtocol: class {
    var id: String { get }
    var teaseURL: URL { get }
    var teaseImage: UIImage? { get }
    var type: NewsItemType { get }
    var imageHeightToWidth: CGFloat? { get }
}

enum NewsItemType: String {
    case section = "Section"
    case article = "article"
    case video = "video"
    case slideshow = "slideshow"
    case none = "NONE"
}

class NewsItem: NSManagedObject, NewsItemProtocol {
    @NSManaged private(set) var id: String
    
    @NSManaged private(set) var teaseURL: URL
    
    var teaseImage: UIImage? {
        guard let data = teaseImageData else {
            return nil
        }
        if currentDataAndImage?.data == data {
            return currentDataAndImage?.image
        }
        if let image = UIImage(data: data) {
            currentDataAndImage = (data: data, image: image)
        }
        return currentDataAndImage?.image
    }
    
    private var currentDataAndImage: (data: Data, image: UIImage)?
    
    @NSManaged private var teaseImageData: Data?
    
    private func calculateImageDimensions() {
        if teaseImage == nil {
            imageHeightToWidth = nil
        } else {
            imageHeightToWidth = teaseImage!.size.height / teaseImage!.size.width
        }
    }
    
    var type: NewsItemType {
        return .none
    }
    
    class var entityName: String {
        return "NewsItemEntity"
    }
    
    private(set) var imageHeightToWidth: CGFloat? = nil
    
    var mediaHeightToWidth: CGFloat? {
        return imageHeightToWidth
    }
    
    func fatalErrorIfBase() {
        fatalError("Please don't create an instance of this class")
    }
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
        if teaseImageData == nil {
            fetchImage()
        } else {
            calculateImageDimensions()
        }
    }
    
    init(id: String, teaseURL: URL, teaseImageData: Data? = nil, entity: NSEntityDescription? = nil) {
        var entityToUse = entity
        if entityToUse == nil {
            entityToUse = NSEntityDescription.entity(forEntityName: NewsItem.entityName, in: NewsItemFactory.shared.persistentcontainer.viewContext)
        }
        super.init(entity: entityToUse!, insertInto: NewsItemFactory.shared.persistentcontainer.viewContext)
        self.id = id
        self.teaseURL = teaseURL
        self.teaseImageData = teaseImageData
        calculateImageDimensions()
        if self.teaseImageData == nil {
            fetchImage()
        }
        fatalErrorIfBase()
    }
    
    override func awakeFromFetch() {
        super.awakeFromFetch()
        NewsItemFactory.shared.registerItem(self)
    }
    
    func updateFromNetwork(teaseURL: URL) {
        guard self.teaseURL != teaseURL else {
            return
        }
        self.teaseURL = teaseURL
        teaseImageData = nil
        fetchImage()
    }
    
    private func fetchImage() {
        NetworkHandler.fetchImage(url: self.teaseURL, successHandler: {[weak self] (imageData) in
            guard self?.teaseImageData != imageData else {
                return
            }
            self?.teaseImageData = imageData
            self?.calculateImageDimensions()
        })
    }
}
