//
//  NewsItemModel.swift
//  nbcNewsfeed
//
//  Created by Yossi Katzin on 4/2/18.
//  Copyright © 2018 Yossi Katzin. All rights reserved.
//

import Foundation
import UIKit

protocol NewsItemProtocol: class {
    var id: String { get }
    var teaseURL: String { get }
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

class NewsItem: NewsItemProtocol {
    private(set) var id: String = ""
    
    private(set) var teaseURL: String = ""
    
    private(set) var teaseImage: UIImage? = nil {
        didSet {
            if teaseImage == nil {
                imageHeightToWidth = nil
            } else {
                imageHeightToWidth = teaseImage!.size.height / teaseImage!.size.width
            }
        }
    }
    
    var type: NewsItemType {
        return .none
    }
    
    private(set) var imageHeightToWidth: CGFloat? = nil
    
    func fatalErrorIfBase() {
        fatalError("Please don't create an instance of this class")
    }
    
    init(id: String, teaseURL: String, teaseImage: UIImage? = nil) {
        sharedInit(id: id, teaseURL: teaseURL, teaseImage: teaseImage)
        fatalErrorIfBase()
    }
    
    func sharedInit(id: String, teaseURL: String, teaseImage: UIImage? = nil) {
        self.id = id
        self.teaseURL = teaseURL
        self.teaseImage = teaseImage
        if teaseImage == nil {
            NetworkHandler.fetchImage(url: self.teaseURL, successHandler: {[weak self] (image) in
                self?.teaseImage = image
            })
        }
    }
}
