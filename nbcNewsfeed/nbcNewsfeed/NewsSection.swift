//
//  NewsSection.swift
//  nbcNewsfeed
//
//  Created by Yossi Katzin on 4/2/18.
//  Copyright © 2018 Yossi Katzin. All rights reserved.
//

import Foundation
import UIKit

class NewsSection: BaseNewsItem {
    override var type: NewsItemType {
        get {
            return .section
        }
    }
    
    override func fatalErrorIfBase() { }
    
    override init(id: String, teaseURL url: String, teaseImage image: UIImage? = nil) {
        super.init(id: id, teaseURL: url, teaseImage: image)
    }
}
