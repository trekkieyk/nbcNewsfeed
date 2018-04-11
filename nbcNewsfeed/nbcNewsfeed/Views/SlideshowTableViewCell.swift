//
//  SlideshowTableViewCell.swift
//  nbcNewsfeed
//
//  Created by Yossi Katzin on 4/10/18.
//  Copyright © 2018 Yossi Katzin. All rights reserved.
//

import UIKit

class SlideshowTableViewCell: SectionItemTableViewCell {
    static let reuseIdentifier: String = "slideshowCell"
    
    static let durationPerItem: TimeInterval = 2.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.stopAnimating()
    }
    
    override func populate(newsItem: NewsSectionItem, withMedia: Bool) {
        guard let slideshow = newsItem as? NewsSlideshow else {
            return
        }
        let images = slideshow.uiImages
        let haveSlides = !images.isEmpty && withMedia
        super.populate(newsItem: newsItem, withMedia: withMedia)
        if haveSlides {
            teaseImage.animationImages = images
            teaseImage.animationDuration = TimeInterval(exactly: images.count)! * SlideshowTableViewCell.durationPerItem
            teaseImage.startAnimating()
        }
    }
    
}
