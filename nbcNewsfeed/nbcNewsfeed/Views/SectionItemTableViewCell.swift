//
//  SectionItemTableViewCell.swift
//  nbcNewsfeed
//
//  Created by Yossi Katzin on 4/3/18.
//  Copyright © 2018 Yossi Katzin. All rights reserved.
//

import UIKit

class SectionItemTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var headline: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var mediaContainerView: UIView!
    @IBOutlet weak var teaseImage: UIImageView!
    @IBOutlet weak var mediaWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var mediaHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headlineTrailingConstraintWithMedia: NSLayoutConstraint!
    @IBOutlet weak var headlineTrailingConstraintWithoutMedia: NSLayoutConstraint!
    @IBOutlet weak var summaryTrailingConstraintWithMedia: NSLayoutConstraint!
    @IBOutlet weak var summaryTrailingConstraintWithoutMedia: NSLayoutConstraint!
    @IBOutlet weak var typeIconYConstraintWithMedia: NSLayoutConstraint!
    @IBOutlet weak var typeIconYConstraintWithoutMedia: NSLayoutConstraint!
    
    static let verticalMargins: CGFloat = 40
    static func headlineWidth(_ withImage: Bool) -> CGFloat {
        return UIScreen.main.bounds.width - 30 - (withImage ? imageWidth + 8 : 0)
    }
    static func summaryWidth(_ withImage: Bool) -> CGFloat {
        return UIScreen.main.bounds.width - 30 - (withImage ? imageWidth + 8 : 0)
    }
    static let imageWidth: CGFloat = 100
    static func heightForDetails(headline: String, summary: String, withImage: Bool, imageHeightToWidth: CGFloat? = nil) -> CGFloat {
        return max(heightForHeadline(headline, withImage: withImage) + heightForSummary(summary, withImage: withImage) + verticalMargins, (imageHeightToWidth ?? 0) * imageWidth + 22)
    }
    static func heightForHeadline(_ text: String, withImage: Bool) -> CGFloat {
        headlineLabelForCalc.text = text
        return headlineLabelForCalc.sizeThatFits(CGSize(width: headlineWidth(withImage), height: .infinity)).height
    }
    static func heightForSummary(_ text: String, withImage: Bool) -> CGFloat {
        summaryLabelForCalc.text = text
        return summaryLabelForCalc.sizeThatFits(CGSize(width: summaryWidth(withImage), height: .infinity)).height
    }
    private static var headlineLabelForCalc: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    private static var summaryLabelForCalc: UILabel = {
        var label = UILabel()
        label.numberOfLines = 3
        label.font = UIFont(descriptor: label.font.fontDescriptor, size: 14)
        return label
    }()
    private static var summaryTextViewForCalc: UITextView = {
        var textView = UITextView()
        textView.isScrollEnabled = false
        textView.contentInset = .zero
        return textView
    }()
    
    func populate(newsItem: NewsSectionItem, withMedia: Bool = true) {
        if withMedia {
            teaseImage.image = newsItem.teaseImage
            mediaHeightConstraint.constant = mediaWidthConstraint.constant * (newsItem.mediaHeightToWidth ?? 0)
        }
        headlineTrailingConstraintWithMedia.isActive = false
        headlineTrailingConstraintWithoutMedia.isActive = false
        summaryTrailingConstraintWithMedia.isActive = false
        summaryTrailingConstraintWithoutMedia.isActive = false
        typeIconYConstraintWithMedia.isActive = false
        typeIconYConstraintWithoutMedia.isActive = false
        headline.text = newsItem.headline
        summaryLabel.text = newsItem.summary
        
        mediaContainerView.isHidden = !withMedia
        headlineTrailingConstraintWithMedia.isActive = withMedia
        headlineTrailingConstraintWithoutMedia.isActive = !withMedia
        summaryTrailingConstraintWithMedia.isActive = withMedia
        summaryTrailingConstraintWithoutMedia.isActive = !withMedia
        typeIconYConstraintWithMedia.isActive = withMedia
        typeIconYConstraintWithoutMedia.isActive = !withMedia
        
        headline.sizeToFit()
        summaryLabel.sizeToFit()
    }
}
