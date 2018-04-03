//
//  ArticleTableViewCell.swift
//  nbcNewsfeed
//
//  Created by Yossi Katzin on 4/2/18.
//  Copyright © 2018 Yossi Katzin. All rights reserved.
//

import UIKit

class ArticleTableViewCell: SectionItemTableViewCell {
    static let reuseIdentifier: String = "articleCell"
    static let verticalMargins: CGFloat = 40
//    static var headlineWidth: CGFloat {
//        return UIScreen.main.bounds.width - 80
//    }
//    static var summaryWidth: CGFloat {
//        return UIScreen.main.bounds.width - 30
//    }
    static func headlineWidth(_ withImage: Bool) -> CGFloat {
        return UIScreen.main.bounds.width - 30 - (withImage ? 108 : 0)
    }
    static func summaryWidth(_ withImage: Bool) -> CGFloat {
        return UIScreen.main.bounds.width - 30 - (withImage ? 108 : 0)
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
        if false {
            return heightForSummaryTextView(text, withImage: withImage)
        } else {
            return heightForSummaryLabel(text, withImage: withImage)
        }
    }
    private static func heightForSummaryLabel(_ text: String, withImage: Bool) -> CGFloat {
        summaryLabelForCalc.text = text
        return summaryLabelForCalc.sizeThatFits(CGSize(width: summaryWidth(withImage), height: .infinity)).height
    }
    private static func heightForSummaryTextView(_ text: String, withImage: Bool) -> CGFloat {
        summaryTextViewForCalc.text = text
        return summaryTextViewForCalc.sizeThatFits(CGSize(width: summaryWidth(withImage), height: .infinity)).height
    }
    private static var headlineLabelForCalc: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    private static var summaryLabelForCalc: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(descriptor: label.font.fontDescriptor, size: 14)
        return label
    }()
    private static var summaryTextViewForCalc: UITextView = {
        var textView = UITextView()
        textView.isScrollEnabled = false
        textView.contentInset = .zero
        return textView
    }()
    
    @IBOutlet weak var headline: UILabel!
    @IBOutlet weak var summary: UITextView?
    @IBOutlet weak var summaryLabel: UILabel?
    @IBOutlet weak var teaseImage: UIImageView!
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headlineTrailingConstraintWithImage: NSLayoutConstraint!
    @IBOutlet weak var headlineTrailingConstraintWithoutImage: NSLayoutConstraint!
    @IBOutlet weak var summaryTrailingConstraintWithImage: NSLayoutConstraint!
    @IBOutlet weak var summaryTrailingConstraintWithoutImage: NSLayoutConstraint!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func populate(newsItem: SectionItemProtocol, withImage: Bool = true) {
        guard let article = newsItem as? NewsArticle else {
            return
        }
        headlineTrailingConstraintWithImage.isActive = withImage
        headlineTrailingConstraintWithoutImage.isActive = !withImage
        summaryTrailingConstraintWithImage.isActive = withImage
        summaryTrailingConstraintWithoutImage.isActive = !withImage
        
        headline.text = article.headline
        headline.sizeToFit()
        summary?.text = article.summary
        summary?.sizeToFit()
        summaryLabel?.text = article.summary
        summaryLabel?.sizeToFit()
        if withImage {
            teaseImage.image = article.teaseImage
            if article.teaseImage != nil {
                imageHeightConstraint.constant = imageWidthConstraint.constant * (article.imageHeightToWidth ?? 0)
            }
        }
        teaseImage.isHidden = !withImage
    }
}
